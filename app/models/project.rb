# frozen_string_literal: true

class Project < ApplicationRecord
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :tags
end