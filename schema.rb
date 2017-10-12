require 'sequel'

DB = Sequel.connect('sqlite://test.db')

DB.create_table :PRODUCT do
  Char :MODEL, fixed: true, size: 6, primary_key: true
  Char :PRODNAME, fixed: true, size:35
  Char :PRODDESC, fixed: true, size: 31
  Numeric :LISTPRICE, size: [9, 2]
end

DB.create_table :COMPONENT do
  Char :COMPID, fixed: true, size: 6, primary_key: true
  Char :COMPTYPE, fixed: true, size: 10
  Char :COMPDESC, fixed: true, size: 31
end

DB.create_table :COMP_USED do
  foreign_key :MODEL, :PRODUCT, fixed: true, size: 6, type: 'Char'
  foreign_key :COMPID, :COMPONENT, fixed: true, size: 6, type: 'Char'
end
