# frozen_string_literal: true

module Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      return (column_names + ransackers.keys) if auth_object == :admin

      const_defined?(:RANSACK_ATTRIBUTES) ? self::RANSACK_ATTRIBUTES : []
    end

    def ransackable_associations(auth_object = nil)
      if auth_object == :admin
        return reflect_on_all_associations.map do |association|
                 association.name.to_s
               end
      end

      const_defined?(:RANSACK_ASSOCIATIONS) ? self::RANSACK_ASSOCIATIONS : []
    end
  end
end
