class PopulateUserRole < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.logger = Logger.new(STDERR)
    # Richard Dale
    u1 = User.find(1)
    u1.role = 'developer'
    u1.administrator = true
    u1.save

    # Paul Sherwood
    u5 = User.find(5)
    u5.role = 'manager'
    u5.administrator = true
    u5.save

    # Rob Taylor
    u6 = User.find(6)
    u6.role = 'manager'
    u6.administrator = true
    u6.save

    # Lars Wirzenius
    u7 = User.find(7)
    u7.role = 'developer'
    u7.administrator = false
    u7.save

    # Daniel Silverstone
    u8 = User.find(8)
    u8.role = 'developer'
    u8.administrator = false
    u8.save

    # Richard Maw
    u9 = User.find(9)
    u9.role = 'developer'
    u9.administrator = false
    u9.save

    # Danny Abukalam
    u10 = User.find(10)
    u10.role = 'developer'
    u10.administrator = false
    u10.save

    # Adnan Ali
    u11 = User.find(11)
    u11.role = 'developer'
    u11.administrator = false
    u11.save

    # Pete Fotheringham
    u12 = User.find(12)
    u12.role = 'developer'
    u12.administrator = false
    u12.save

    # Marc Dunford
    u13 = User.find(13)
    u13.role = 'sales'
    u13.administrator = false
    u13.save

    # Aaron Greenall
    u14 = User.find(14)
    u14.role = 'sales'
    u14.administrator = false
    u14.save

    # Karl Lattimer
    u16 = User.find(16)
    u16.role = 'developer'
    u16.administrator = false
    u16.save

    # Sam Thursfield
    u17 = User.find(17)
    u17.role = 'developer'
    u17.administrator = false
    u17.save

    # Ben Brewer
    u18 = User.find(18)
    u18.role = 'developer'
    u18.administrator = false
    u18.save

    # Dan Firth
    u19 = User.find(19)
    u19.role = 'developer'
    u19.administrator = false
    u19.save

    # Javier Jardon
    u20 = User.find(20)
    u20.role = 'developer'
    u20.administrator = false
    u20.save

    # Alex Brankov
    u23 = User.find(23)
    u23.role = 'manager'
    u23.administrator = false
    u23.save

    # Maria Turk
    u27 = User.find(27)
    u27.role = 'developer'
    u27.administrator = false
    u27.save

    # Gabriel Vizzard
    u30 = User.find(30)
    u30.role = 'developer'
    u30.administrator = false
    u30.save

    # Jannis Pohlmann
    u31 = User.find(31)
    u31.role = 'developer'
    u31.administrator = false
    u31.save

    # Stephen Jones
    u32 = User.find(32)
    u32.role = 'manager'
    u32.administrator = false
    u32.save

  end

  def self.down
  end
end
