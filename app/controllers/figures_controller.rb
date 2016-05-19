class FiguresController < ApplicationController
  
  get '/figures' do
    @figures = Figure.all
    erb :'/figures/index'
  end

  get '/figures/new' do

    erb :'/figures/new'
  end

  post '/figures' do    
    @figure = Figure.create(params["figure"])
      if !params[:landmark][:name].empty?
        @figure.landmarks << Landmark.find_or_create_by(params[:landmark])
      end

      if !params[:title][:name].empty?
        @figure.titles << Title.find_or_create_by(params[:title])
      end
      
      @figure.save
      redirect to "/figures/#{@figure.id}"

    redirect "/figures/#{@figure.id}"
  end

  get '/figures/:id' do
    @figure = Figure.find_by(id: params[:id])
    erb :'/figures/show'
  end

  get '/figures/:id/edit' do
    @figure = Figure.find_by(id: params[:id])
    erb :'/figures/edit'
  end

  patch '/figures/:id' do
    @figure = Figure.find_by(id: params[:id])
    @figure.titles.clear
    @figure.landmarks.clear
    @figure.update(name: params[:figure][:name])
    
    create_or_update_landmark(params[:figure][:landmark_ids], params[:landmark][:name])
    create_or_update_title(params[:figure][:title_ids], params[:title][:name])

    @figure.save
    
    redirect "/figures/#{@figure.id}"
  end

end