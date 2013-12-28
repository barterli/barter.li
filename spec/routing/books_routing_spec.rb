require "spec_helper"

describe BooksController do
  describe "routing" do

    it "routes to #index" do
      get("/books").should route_to("books#index")
    end

    it "routes to #new" do
      get("/books/new").should route_to("books#new")
    end

    it "routes to #show" do
      get("/books/1").should route_to("books#show", :id => "1")
    end

    it "routes to #edit" do
      get("/books/1/edit").should route_to("books#edit", :id => "1")
    end

    it "routes to #create" do
      post("/books").should route_to("books#create")
    end

    it "routes to #update" do
      put("/books/1").should route_to("books#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/books/1").should route_to("books#destroy", :id => "1")
    end

  end
end
