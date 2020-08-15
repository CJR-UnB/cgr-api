module SoftDeletable
    extend ActiveSupport::Concern
  
    included do
      default_scope { where(deleted_at: nil) }
      scope :only_deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }
    end
  
    def delete
      update_column :deleted_at, DateTime.now if has_attribute? :deleted_at
    end
  
    def destroy;
      callbacks_result = transaction do
        run_callbacks(:destroy) do
          delete
        end
      end
      callbacks_result ? self : false
    end
  
    def self.included(klazz)
      klazz.extend Callbacks
    end
  
    module Callbacks
      def self.extended(klazz)
        klazz.define_callbacks :restore
        klazz.define_singleton_method("before_restore") do |*args, &block|
          set_callback(:restore, :before, *args, &block)
        end
        klazz.define_singleton_method("around_restore") do |*args, &block|
          set_callback(:restore, :around, *args, &block)
        end
        klazz.define_singleton_method("after_restore") do |*args, &block|
          set_callback(:restore, :after, *args, &block)
        end
      end
    end
  
    def restore!(opts = {})
      self.class.transaction do
        run_callbacks(:restore) do
          update_column :deleted_at, nil
          restore_associated_records if opts[:recursive]
        end
      end
      self
    end
  
    alias :restore :restore!
  
    def restore_associated_records
      destroyed_associations = self.class.reflect_on_all_associations.select do |association|
        association.options[:dependent] == :destroy
      end
      destroyed_associations.each do |association|
        association_data = send(association.name)
        unless association_data.nil?
          if association_data.is_deleted?
            if association.collection?
              association_data.only_deleted.each { |record| record.restore(recursive: true) }
            else
              association_data.restore(recursive: true)
            end
          end
        end
        if association_data.nil? && association.macro.to_s == 'has_one'
          association_class_name = association.options[:class_name].present? ? association.options[:class_name] : association.name.to_s.camelize
          association_foreign_key = association.options[:foreign_key].present? ? association.options[:foreign_key] : "#{self.class.name.to_s.underscore}_id"
          Object.const_get(association_class_name).only_deleted.where(association_foreign_key, self.id).first.try(:restore, recursive: true)
        end
      end
      clear_association_cache if destroyed_associations.present?
    end
end