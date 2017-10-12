require 'factory_girl'
require 'sequel'

# Adapting Sequel to apeal the girl
# Check the "The save! caveat" section at...
# https://workaround.org/articlefactorygirl-test-padrino-sequel/
class Sequel::Model
  alias_method :save!, :save
end

DB = Sequel.connect('sqlite://test.db')

class Product < Sequel::Model(:PRODUCT);end
Product.unrestrict_primary_key

class Component < Sequel::Model(:COMPONENT);end
Component.unrestrict_primary_key

Product.create(
  MODEL:     "ZTC1",
  PRODNAME:  "Zetec ONE",
  PRODDESC:  "Easy to use Personal Computer",
  LISTPRICE: 100.0)

FactoryGirl.define do
  factory :component do
    COMPID   "CMP1"
    COMPTYPE "Monitor"
    COMPDESC '13" CRT White'
  end
end

FactoryGirl.create(:component)