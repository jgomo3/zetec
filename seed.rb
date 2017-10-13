require 'factory_girl'
require 'sequel'

# Adapting Sequel to apeal the girl
# Check the "The save! caveat" section at...
# https://workaround.org/articlefactorygirl-test-padrino-sequel/
class Sequel::Model
  alias_method :save!, :save
end

DB = Sequel.connect('sqlite://test.db')

class Product < Sequel::Model(:PRODUCT)
  many_to_many :components, left_key: :MODEL, right_key: :COMPID, join_table: :COMP_USED
end
Product.unrestrict_primary_key

class Component < Sequel::Model(:COMPONENT)
  many_to_many :products, left_key: :COMPID, right_key: :MODEL, join_table: :COMP_USED
end
Component.unrestrict_primary_key

FactoryGirl.define do
  factory :component do
    sequence(:COMPID) { |n| "CMP#{n}" }

    trait :monitor do
      COMPTYPE "monitor"
      COMPDESC '13" CRT White'
    end

    trait :no_monitor do
      sequence(:COMPTYPE) { |n| "GEAR#{n%10}" }
      COMPDESC "Just a gear"
    end
  end
end

MONITORS = FactoryGirl.create_list(:component, 10, :monitor)
GEARS = FactoryGirl.create_list(:component, 90, :no_monitor)

FactoryGirl.define do
  sequence :monitor do |n|
    MONITORS[n%MONITORS.length]
  end

  sequence :gear do |n|
    GEARS[n%GEARS.length]
  end

  factory :product do
    sequence(:MODEL) { |n| "ZTC#{n}" }
    sequence(:PRODNAME) { |n| "Zetec #{n}" }
    PRODDESC  "Easy to use Personal Computer"
    LISTPRICE 1000

    after :create do |p|
      3.times { p.add_component(generate(:gear)) }
    end

    trait :with_monitor do
      after :create do |p|
        p.add_component(generate(:monitor))
      end
    end
  end
end

FactoryGirl.create_list(:product, 50, :with_monitor)
FactoryGirl.create_list(:product, 100)