require_relative 'questions_db'
require_relative 'users'
require_relative 'questions'

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
  
  def self.followers_for_question_id(question_id)
    data = QuestionsDB.instance.execute(<<-SQL, question_id)
       SELECT 
        users.id, users.fname, users.lname
       FROM
        users 
        JOIN question_follows ON users.id = question_follows.user_id
        JOIN questions ON questions.id = question_follows.question_id
       WHERE
        question_follows.question_id = ?
    SQL
    data.map {|user| Users.new(user) }  
  end
  
  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDB.instance.execute(<<-SQL, user_id)
       SELECT 
        questions.id, questions.title, questions.body, questions.user_id
       FROM
        questions 
        JOIN question_follows ON questions.id = question_follows.question_id
        JOIN users ON users.id = question_follows.user_id
       WHERE
        question_follows.user_id = ?
    SQL
    data.map {|question| Questions.new(question) }  
  end
  
  def self.most_followed_questions(n)
    data = QuestionsDB.instance.execute(<<-SQL, n)
       SELECT 
          questions.id, questions.title, questions.body, questions.user_id, COUNT(question_follows.user_id) as follow_number
       FROM
          questions 
        JOIN question_follows ON questions.id = question_follows.question_id
        GROUP BY
          questions.id
        ORDER BY
          follow_number DESC
        LIMIT ?
    SQL
  end
  
end