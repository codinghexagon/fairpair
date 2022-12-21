class UserProjectPolicy < ApplicationPolicy

  def destroy?
    current_user.lead? && @record.user.lead.id.eql?(current_user.id)
  end
end
