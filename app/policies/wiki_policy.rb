class WikiPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    if record.private?
      user.admin? || user.premium?
    else
      user.present?
    end
  end

  def create?
    if record.private?
      user.admin? || user.premium?
    else
      user.present?
    end
  end

  def new?
    create?
  end

  def update?
    user.present?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin? || user.premium?
        scope
      else
        scope.where(private: false)
      end
    end
  end
end
