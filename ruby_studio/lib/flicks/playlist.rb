require_relative 'movie'
require_relative 'waldorf_and_statler'
require_relative 'snack_bar'

module Flicks
  class Playlist
    def initialize(name)
      @name = name
      @movies = []
    end

    def load(from_file)
      File.readlines(from_file).each do |line|
        add_movie Movie.from_csv(line)
      end
    end

    def save(to_file="movie_rankings.csv")
      File.open(to_file, "w") do |file|
        @movies.sort.each do |movie|
          file.puts movie.to_csv
        end
      end
    end

    def add_movie movie
      @movies << movie
    end

    def play(viewings)
      puts "#{@name}'s playlist"
      puts @movies


      snacks = SnackBar::SNACKS
      puts "\nThere are #{snacks.size} snacks available in the snack bar"
      snacks.each do |snack|
        puts "#{snack.name} has #{snack.carbs} carbs."
      end

      1.upto(viewings) do |count|
        puts "\nViewing #{count}"
        @movies.each do |m|
          WaldorfAndStatler.review(m)
          snack = SnackBar.random
          m.ate_snack(snack)
          puts m
        end
      end
    end

    def total_carbs_consumed
      @movies.reduce(0) do |sum, movie|
        sum + movie.carbs_consumed
      end
    end

    def print_stats
      puts "\n#{@name}'s Stats"

      puts "#{total_carbs_consumed} total carbs consumed"

      @movies.sort.each do |movie|
        puts "\n#{movie.title}'s snack totals:"
        movie.each_snack do |snack|
          puts "#{snack.carbs} total carbs for #{snack.name}"
        end

        puts "\n#{movie.carbs_consumed} grand total carbs."
      end

      hits, flops = @movies.partition { |movie| movie.hit? }

      puts "\nHits:"
      puts hits.sort

      puts "\nFlops:"
      puts flops.sort
    end
  end
end
