class ResultPolicy < ApplicationPolicy
  def create?
    user.athlete?
  end
end
