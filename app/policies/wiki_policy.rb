class WikiPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    if user && user.admin?
      true
    elsif user && user.premium?
      !record.private || record.user == user || record.collaborators.exists?(user_id: user.id)
    else
      !record.private || record.collaborators.exists?(user_id: user.id)
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
    if record.private?
      user.admin? || user.premium?
    else
      user.present?
    end
  end

  def edit?
    update?
  end

  def destroy?
    user && user.admin?
  end

  class Scope < Scope
    def resolve
      wikis = []
        if user && user.admin?
          wikis = scope.all
        elsif user && user.premium?
          scope.all.each do |wiki|
            if !wiki.private || wiki.user == user || wiki.collaborators.exists?(user_id: user.id)
              wikis << wiki
            end
          end
        else
          scope.all.each do |wiki|
            if !wiki.private || wiki.collaborators.exists?(user_id: user.id)
              wikis << wiki
            end
          end
        end
        wikis
    end
  end
end
