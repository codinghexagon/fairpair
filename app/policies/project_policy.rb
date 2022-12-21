class ProjectPolicy < ApplicationPolicy

  def index?
    current_user.lead?
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def show?
    current_user.lead? && @record.users&.lead&.first&.id.eql?(current_user.id)
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

  def manage_developers?
    show?
  end

  def add_developer?
    show?
  end
end
