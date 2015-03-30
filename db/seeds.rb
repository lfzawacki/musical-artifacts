# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

License.create short_name: 'by', name: 'This work is licensed under a Creative Commons Attribution 3.0 Unported License.'
License.create short_name: 'by_sa', name: 'This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License.'
License.create short_name: 'by_nd', name: 'This work is licensed under a Creative Commons Attribution-NoDerivs 3.0 Unported License.'
License.create short_name: 'by_nc', name: 'This work is licensed under a Creative Commons Attribution-NonCommercial 3.0 Unported License.'
License.create short_name: 'by_nc_sa', name: 'This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.'
License.create short_name: 'by_nc_nd', name: 'This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.'