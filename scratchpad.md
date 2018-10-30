# Scratchpad

## href_create

type_of, ':'
'property/:id/libraries'
'company'
p = Property.new(name: 'name', company_id: '').save
# we create a proto company object
p.company.id #not loaded
p.company.name # hits method missing and is loaded

p = Property.new(name: 'name', company: $unsaved_company).save

p = Property.new(name: 'name', company: $saved_company).save
