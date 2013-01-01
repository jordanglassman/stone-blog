class Post < ActiveRecord::Base
  include FriendlyId
  
  attr_accessible :body, :published_at, :slug, :title, :tag_list, :state
  
  has_many :taggings
  has_many :tags, through: :taggings
  validates :tag_list, :format => { :with => /^(\w+\s*,\s*)*\w+$|^\s*$/, :message => "must be a comma-separated list of words containing only letters and numbers." }
  
  validates :title, :presence => true
  validates :title, :format => { :with => /[A-Za-z0-9\- ]+/, :message => "can contain only letters, numbers, spaces, and hyphens." }

  # only convert the title to slug if no custom slug given or on subsequent updates
  friendly_id :title, :use => :slugged
  def should_generate_new_friendly_id?
    self.slug.blank? && new_record? 
  end
  
  validates :slug, :uniqueness => true, :presence => true
  validates :slug, :format => { :with => /[A-Za-z0-9\-]+/, :message => "can contain only letters, numbers, and hyphens." }
      
  validates :body, :format => { :with => /^[A-Za-z0-9\-\#\*\.\[\]\>\_\\ ]*$/, :message => "can contain only valid markdown characters." }
      
  scope :time_ordered, order('created_at desc')
  scope :with_state, lambda { |state| state.present? ? { :conditions => {:state => state} } : {} }
  
  # will_paginate config
  self.per_page = 20

  state_machine :state, :initial => :draft do

    after_transition [:draft, :finalized] => :published do |post, transition|
      post.published_at = Time.zone.now
      post.save
    end
    
    after_transition :draft => same do |post, transition|
      # do nothing, but don't save
    end
    
    after_transition :draft => :tossed do |post, transition|
      post.destroy
    end

    event :save_draft do
      transition :draft => same
    end

    event :finalize do
      transition :draft => :finalized
    end
    
    event :publish do
      transition [:draft, :finalized] => :published
    end
    
    event :toss do
      transition [:draft, :finalized, :published] => :tossed
    end
    
    state :draft do
      def savable?
        true
      end
      
      def finalizable?
        true
      end
          
      def editable?
        true
      end
    end
    
    state :finalized do
    end
    
    state :published do
    end
    
    state :tossed do
      def tossable?
        false
      end
    end
    
    state all - :tossed do
      def tossable?
        true
      end
    end
    
    state all - :draft do
      def savable?
        false
      end
      
      def finalizable?
        false
      end
      
      def editable?
        false
      end
    end
    
    state all - [:draft, :finalized] do
      def publishable?
        false
      end
    end
    
    state :draft, :finalized do
      def publishable?
        true
      end
    end
    
  end
    
  # taken from http://railscasts.com/episodes/382-tagging
  def self.tagged_with(name)
    Tag.find_by_name!(name).posts
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
      joins(:taggings).group("taggings.tag_id")
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

end
