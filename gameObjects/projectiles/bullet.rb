require_relative "./projectile.rb"
class Bullet < Projectile
  def initialize(center=Vector[0,0],velocity=Vector[0,0],damage=10,width=2,height=2)
    super center,velocity,damage,width,height
  end
end