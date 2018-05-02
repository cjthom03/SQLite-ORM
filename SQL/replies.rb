require_relative 'questions_db' 
require_relative 'questions'
require_relative 'users'

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
  
  def self.find_by_user_id(user_id)
    data = QuestionsDB.instance.execute(<<-SQL, user_id)
       SELECT 
        * 
       FROM
        replies
       WHERE
        replies.user_id = ?
    SQL
    data.map {|reply| Replies.new(reply) }  
  end
  
  def self.find_by_question_id(question_id)
    data = QuestionsDB.instance.execute(<<-SQL, question_id)
       SELECT 
        * 
       FROM
        replies
       WHERE
        replies.question_id = ?
    SQL
    data.map {|reply| Replies.new(reply) }  
  end
  
  def self.find_by_parent_id(parent_id)
    data = QuestionsDB.instance.execute(<<-SQL, parent_id)
       SELECT 
        * 
       FROM
        replies
       WHERE
        replies.parent_reply_id = ?
    SQL
    data.map {|reply| Replies.new(reply) }  
  end
  
  def author
    Users.find_by_id(@user_id)
  end
  
  def question 
    Questions.find_by_id(@question_id)
  end
  
  def parent_reply 
    Replies.find_by_id(@parent_reply_id)
  end
  
  def child_replies
    Replies.find_by_parent_id(@id)
  end 
  
  def save
    raise 'Already exists' if @id 
    QuestionsDB.instance.execute(<<-SQL, @question_id, @user_id, @parent_reply_id, @content)
      INSERT INTO 
        replies(question_id, user_id, parent_reply_id, content)
      VALUES
        (?, ?, ?, ?)
      SQL
      
      @id = QuestionsDB.instance.last_insert_row_id
  end
  
end
# 
