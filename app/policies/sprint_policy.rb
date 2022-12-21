class SprintPolicy < ApplicationPolicy

  def initialize(user, resource)
  end

  def index?
    current_user.lead?
  end

  def create?
    index?
  end
end
