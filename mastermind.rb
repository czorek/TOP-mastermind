class Game

  attr_accessor :num_range, :turns, :p_guess

  def initialize
    puts instructions
    take_info
    new_game    
  end

  private

  def instructions
    "\nWelcome to Mastermind!\n
    Your goal in each turn is to guess the 4-digits-long secret code,
    made of up to 10 digits (including 0). Duplicates are possible. You can specify the number of digits
    when the game starts (no less than 6), and the number of turns (8, 10 or 12) the game will last.
    You can guess by providing an answer in the format '0000' when prompted. Your each guess will be scored
    in the following way: the first number tells you how many exact hits you had (digit and position),
    and the second - only digit hits.\n\n"
  end

  def take_info
    range = 0
    turns = 0
    until (6..10).include? range
      puts "Please specify the amount of numbers to choose the code from - 6 to 10: "
      range = gets.chomp.to_i
      puts ' '
    end

    until [8, 10, 12].include? turns
      puts "Please choose the number of turns - 8, 10 or 12."
      turns = gets.chomp.to_i
      puts ' '
    end

    @num_range = range
    @turns = turns
  end

  def generate_code
    code = []
    4.times {code << rand(@num_range)}
    code
  end

  def guess
    @p_guess = []
    @p_guess = gets.chomp.split('').map! { |i| i.to_i }
    if @p_guess.size != 4
      puts "Invalid guess. Please provide 4 digits."
      guess
    else
      @p_guess
    end
  end

  def score(s_code)
    temp = @p_guess.dup
    black_count = s_code.zip(@p_guess).find_all { |a, b| a==b }.count
    white_count = s_code.inject(0) do |mem, peg|
        if index = temp.index(peg)
          temp.delete_at index
          mem += 1
        end
        mem
      end
    "#{black_count}, #{white_count - black_count}."
  end

  def check_win(s)
    win = false
    win = true if s == "4, 0."
  end

  def restart(str)
    win_msg = "You guessed the secret code!\n"
    lose_msg = "Looks like you lost..."

    case str
      when 'win' then puts win_msg
      when 'lose' then puts lose_msg
    end

    puts "Play again? (y/n)"
    answer = gets.chomp.downcase
    if answer == 'y'
      reset_state
      new_game
    else
      exit
    end
  end

  def reset_state
    take_info
  end

  def new_game
    secret_code = generate_code
    while @turns > 0
      puts "#{@turns} turns left. Your guess?"
      guess
      restart ('win') if check_win(score(secret_code))
      puts "#{@p_guess.to_s}, scored #{score(secret_code)}"
      @turns -= 1
    end
    restart('lose')
  end
end

p = Game.new