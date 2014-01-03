require "spec_helper"

describe Notifier do
  describe "wish_list_book" do
    let(:mail) { Notifier.wish_list_book }

    it "renders the headers" do
      mail.subject.should eq("Wish list book")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
