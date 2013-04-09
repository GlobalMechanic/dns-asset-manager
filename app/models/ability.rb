class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :animator
      can :manage, :all
      cannot :manage, User
    elsif user.id?
      #can(:manage, Reel) { |reel| user.reels.include?(reel)  }
      can :read, :all
      can :type, Asset # asset browsing by type
      can :download, Asset # asset browsing by type
      can :keyword, Asset # asset browsing by type
      cannot :manage, User
      #cannot [:create, :update, :destroy], Asset
      can :manage, ReelAsset
      can :manage, Reel, :user_id => user.id
    else
      can :download, Asset
    end

    #puts 'WHEN DOES THIS GET CALLED? ' + user.id.to_s
    #can(:manage, :all) if user.has_role? :admin
    #can(:manage, Reel) { |reel| false }
    #can :destroy, Reel, :id => Reel.user_id = user.id
    #can(:manage, Reel) { |reel| true }
    #can :manage, Reel, :user_id => false
    #can(:manage, Reel) {|reel| false }


      # if user.admin?
      #   can :manage, :all
      # else
      #   can :read, :all
      # end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
