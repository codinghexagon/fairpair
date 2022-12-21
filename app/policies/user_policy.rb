class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @record = model
  end

  def new?
    current_user.lead?
  end

  def create?
    new?
  end

  def show?
    current_user.lead? && @record.lead.id.eql?(current_user.id)
  end

  def edit?
    show?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end
end
