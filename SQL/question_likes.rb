require_relative 'questions_db'
require_relative 'users'

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
  
  def self.likers_for_question_id(question_id)
    data = QuestionsDB.instance.execute(<<-SQL, question_id)
       SELECT 
        users.id, users.fname, users.lname
       FROM
        users 
        JOIN
        question_likes ON question_likes.user_id = users.id   
       WHERE 
       question_likes.question_id = ?
       
    SQL
    data.map {|user| Users.new(user) } 
  end
  
  def self.num_likes_for_question_id(question_id)
    data = QuestionsDB.instance.execute(<<-SQL, question_id)
       SELECT 
        COUNT(question_likes.user_id) as num_likes
       FROM
        users 
        JOIN
        question_likes ON question_likes.user_id = users.id   
       WHERE 
        question_likes.question_id = ?
       GROUP BY
        question_likes.question_id   
    SQL
    data.map {|likes| likes['num_likes'] }.first
  end
  
  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDB.instance.execute(<<-SQL, user_id)
       SELECT 
        questions.id, questions.title, questions.body, questions.user_id
       FROM
        questions
        JOIN
        question_likes ON question_likes.question_id = questions.id   
       WHERE 
       question_likes.user_id = ?
    SQL
    data.map {|question| Questions.new(question) } 
  end
  
  def self.most_liked_questions(n)
    data = QuestionsDB.instance.execute(<<-SQL, n)
       SELECT 
        questions.id, questions.title, questions.body, questions.user_id, COUNT(question_likes.id) AS num_likes
       FROM
        questions
        JOIN
        question_likes ON question_likes.question_id = questions.id   
        GROUP BY 
        questions.id 
        ORDER BY 
        num_likes DESC
        LIMIT
        ?
    SQL
    data.map {|question| Questions.new(question) } 
  end 
end
