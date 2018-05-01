require 'sqlite3'
require 'singleton'
require 'byebug'

class QuestionsDB < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Questions 
  attr_accessor :title, :body, :user_id
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end
  
  def self.all 
      data = QuestionsDB.instance.execute('SELECT * FROM questions')
      data.map {|questions| Questions.new(questions) }
  end 
  
  def self.find_by_id(id)
    data = QuestionsDB.instance.execute(<<-SQL, id)
       SELECT 
        * 
       FROM
        questions
       WHERE
        id = ?
    SQL
    data.map {|questions| Questions.new(questions)  }
  end 
end

class Users 
  
  attr_accessor :fname, :lname
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def self.all 
    data = QuestionsDB.instance.execute('SELECT * FROM users')
    data.map { |users| Users.new(users) }
  end
  
  def self.find_by_id(id)
    data = QuestionsDB.instance.execute(<<-SQL, id)
       SELECT 
        * 
       FROM
        users
       WHERE
        id = ?
    SQL
    data.map {|users| Users.new(users) }  
  end
  
  def self.find_by_name(fname, lname)
    data = QuestionsDB.instance.execute(<<-SQL, fname, lname)
       SELECT 
        * 
       FROM
        users
       WHERE
        fname LIKE ? AND
        lname LIKE ?
    SQL
    data.map {|users| Users.new(users) }  
  end
end


# CREATE TABLE question_follows(
#   id  INTEGER PRIMARY KEY,
#   question_id INTEGER NOT NULL, 
#   user_id INTEGER NOT NULL,
# 

class QuestionFollows
  attr_accessor :question_id, :user_id
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
  
  def self.all 
    data = QuestionsDB.instance.execute('SELECT * FROM question_follows')
    data.map { |question_follows| QuestionFollows.new(question_follows) }
  end
  
  def self.find_by_id(id)
    data = QuestionsDB.instance.execute(<<-SQL, id)
       SELECT 
        * 
       FROM
        question_follows
       WHERE
        id = ?
    SQL
    data.map {|question_follows| QuestionFollows.new(question_follows) }  
  end
  
end


# 
# CREATE TABLE replies (
#   id INTEGER PRIMARY KEY,
#   question_id INTEGER NOT NULL,
#   parent_reply_id INTEGER, 
#   user_id INTEGER NOT NULL,
#   content TEXT NOT NULL,
# 

class Replies
  attr_accessor :question_id, :parent_reply_id, :user_id, :content
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @user_id = options['user_id']
    @content = options['content']
  end
  
  def self.all 
    data = QuestionsDB.instance.execute('SELECT * FROM replies')
    data.map { |replies| Replies.new(replies) }
  end
  
  def self.find_by_id(id)
    data = QuestionsDB.instance.execute(<<-SQL, id)
       SELECT 
        * 
       FROM
        replies
       WHERE
        id = ?
    SQL
    data.map {|replies| Replies.new(replies) }  
  end
  
end
# 
# CREATE TABLE question_likes (
#   id  INTEGER PRIMARY KEY,
#   question_id INTEGER NOT NULL, 
#   user_id INTEGER NOT NULL,

class QuestionLikes
  attr_accessor :question_id, :user_id
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
  
  def self.all 
    data = QuestionsDB.instance.execute('SELECT * FROM question_likes')
    data.map { |question_likes| QuestionLikes.new(question_likes) }
  end
  
  def self.find_by_id(id)
    data = QuestionsDB.instance.execute(<<-SQL, id)
       SELECT 
        * 
       FROM
        question_likes
       WHERE
        id = ?
    SQL
    data.map {|question_likes| QuestionLikes.new(question_likes) }  
  end
  
end
