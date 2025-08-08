class TransactionTemplate < ApplicationRecord
  belongs_to :family
  belongs_to :account, optional: true
  belongs_to :category, optional: true

  scope :alphabetically, -> { order(name: :asc) }
end
