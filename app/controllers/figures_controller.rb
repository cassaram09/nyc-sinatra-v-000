class FiguresController < ApplicationController
  
  get '/figures' do
    @figures = Figure.all
    erb :'/figures/index'
  end

  get '/figures/new' do

    erb :'/figures/new'
  end

  post '/figures' do
    @figure = Figure.create(name: params[:figure][:name])
    
    create_or_update_landmark(params[:figure][:landmark_ids], params[:landmark][:name])
    create_or_update_title(params[:figure][:title_ids], params[:title][:name])

    @figure.save

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

   helpers do
    def create_or_update_landmark(existing_property, new_property)
      if existing_property
        existing_property.each do |id|
          @figure.landmarks << Landmark.find_by(id: id)
        end
      end

      @figure.save

      if new_property != "" 
        @figure.landmarks << Landmark.find_or_create_by(name: new_property)
      end
    end

    def create_or_update_title(existing_property, new_property)
      if existing_property
        existing_property.each do |id|
          @figure.titles << Title.find_by(id: id)
        end
      end

      @figure.save
      
      if new_property != "" 
        @figure.titles << Title.find_or_create_by(name: new_property)
      end
    end

  end

end