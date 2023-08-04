class CompetitionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.committee?
  end

  def close?
    user.committee?
  end
end
