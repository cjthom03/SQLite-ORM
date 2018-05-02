require_relative 'questions_db'
require_relative 'questions'
require_relative 'replies'
require_relative 'question_likes'

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
  
  def authored_questions
    Questions.find_by_author_id(@id)
  end
  
  def authored_replies
    Replies.find_by_user_id(@id)
  end
  
  def followed_questions 
    QuestionFollows.followed_questions_for_user_id(@id)
  end
  
  def liked_questions
    QuestionLikes.liked_questions_for_user_id(@id)
  end
  
  def average_karma
    data = QuestionsDB.instance.execute(<<-SQL, @id)
      SELECT
        CAST(COUNT(question_likes.id) AS FLOAT) / COUNT(DISTINCT (questions.id)) 
      FROM
        questions
        LEFT OUTER JOIN question_likes
        ON questions.id = question_likes.question_id
        WHERE 
        questions.user_id = ?
      
    
    SQL
    # data.map {|user| Users.new(user) } 
  end 
  
  def save 
    raise 'Already exist' if @id
    data = QuestionsDB.instance.execute(<<-SQL, @fname,@lname)
    INSERT INTO 
    users  (fname,lname)
    VALUES
    (?,?)
    SQL
    @id = QuestionsDB.instance.last_insert_row_id
  end 
  
end
