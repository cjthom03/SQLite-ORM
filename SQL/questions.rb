require_relative 'questions_db'
require_relative 'users'
require_relative 'replies'
require_relative 'question_follows'
require_relative 'question_likes'

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
  
  def self.find_by_author_id(author_id)
    data = QuestionsDB.instance.execute(<<-SQL, author_id)
       SELECT 
        * 
       FROM
        questions
       WHERE
        questions.user_id = ?
    SQL
    data.map {|questions| Questions.new(questions) }  
  end
    
  def author
    Users.find_by_id(@user_id)
  end
  
  def replies 
    Replies.find_by_question_id(@id)
  end
  
  def followers 
    QuestionFollows.followers_for_question_id(@id)
  end
  
  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end 
  
  def likers 
    QuestionLikes.likers_for_question_id(@id)
  end
  
  def num_likes
    QuestionLikes.num_likes_for_question_id(@id)
  end
  
  def self.most_liked(n)
    QuestionLikes.most_liked_questions(n)
  end 

  def save
    raise 'Already exists!' if @id
    QuestionsDB.instance.execute(<<-SQL, @title, @body, @user_id)
      INSERT INTO 
        questions (title, body, user_id)
      VALUES
        (?, ?, ?)
      SQL
    
    @id = QuestionsDB.instance.last_insert_row_id
  end
  
end



