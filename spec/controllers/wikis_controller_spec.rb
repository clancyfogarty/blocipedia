require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_wiki) { create(:wiki) }
  let(:other_user) { create(:user) }

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns Wiki.all to wiki" do
      get :index
      expect(assigns(:wikis)).to eq([my_wiki])
    end
  end

  context "signed in standard user" do
    before do
      sign_in other_user
      other_wiki = Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: other_user, private: false)
      sign_out other_user
      sign_in my_user
    end

    describe "GET show" do
      it "returns http success" do
        get :show, params: { id: my_wiki.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the show view" do
        get :show, params: { id: my_wiki.id }
        expect(response).to render_template :show
      end

      it "assigns my_wiki to @wiki" do
        get :show, params: { id: my_wiki.id }
        expect(assigns(:wiki)).to eq(my_wiki)
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new, params: { title: my_wiki.title, body: my_wiki.body, private: my_wiki.private, user: my_wiki.user }
        expect(response).to have_http_status(:success)
      end

      it "renders the new view" do
        get :new, params: { title: my_wiki.title, body: my_wiki.body, private: my_wiki.private, user: my_wiki.user }
        expect(response).to render_template :new
      end

      it "instantiates @wiki" do
        get :new, params: { title: my_wiki.title, body: my_wiki.body, private: my_wiki.private, user: my_wiki.user }
        expect(assigns(:wiki)).not_to be_nil
      end
    end

    describe "POST create public wiki" do
      it "increases the number of Wiki by 1" do
        expect{ post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false} } }.to change(Wiki,:count).by(1)
      end

      it "assigns the new wiki to @wiki" do
        post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false} }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the new wiki" do
        post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false} }
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "POST create private wiki" do
      it "does not allow for a private wiki to be created" do
        expect{ post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true} } }.to change(Wiki, :count).by(0)
      end
    end

    context "own users's post" do
      describe "GET edit" do
        it "returns http success" do
          get :edit, params: { id: my_wiki.id }
          expect(response).to have_http_status(:success)
        end

        it "renders the #edit view" do
          get :edit, params: { id: my_wiki.id }
          expect(response).to render_template :edit
        end

        it "assigns wiki to be updated to @wiki" do
          get :edit, params: { id: my_wiki.id }
          wiki_instance = assigns(:wiki)

          expect(wiki_instance.id).to eq my_wiki.id
          expect(wiki_instance.title).to eq my_wiki.title
          expect(wiki_instance.body).to eq my_wiki.body
        end
      end

      describe "PUT update" do
        it "updates wiki with expected attributes" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: { id: my_wiki.id, wiki: { title: new_title, body: new_body } }

          updated_wiki = assigns(:wiki)
          expect(updated_wiki.id).to eq my_wiki.id
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
        end

        it "redirects to the updated wiki" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: { id: my_wiki.id, wiki: { title: new_title, body: new_body } }
          expect(response).to redirect_to my_wiki
        end
      end

      describe "DELETE destroy" do
        it "does not delete the wiki" do
          delete :destroy, params: { id: my_wiki.id }
          count = Wiki.where({id: my_wiki.id}).size
          expect(count).to eq 1
        end

        it "redirects to wiki index" do
          delete :destroy, params: { id: my_wiki.id }
          expect(response).to redirect_to wikis_path
        end
      end
    end

    context "standard user editing not their wiki" do
      before do
        sign_in other_user
      end

      describe "GET edit" do
        it "returns http success" do
          get :edit, params: { id: my_wiki.id }
          expect(response).to have_http_status(:success)
        end

        it "renders the #edit view" do
          get :edit, params: { id: my_wiki.id }
          expect(response).to render_template :edit
        end

        it "assigns wiki to be updated to @wiki" do
          get :edit, params: { id: my_wiki.id }
          wiki_instance = assigns(:wiki)

          expect(wiki_instance.id).to eq my_wiki.id
          expect(wiki_instance.title).to eq my_wiki.title
          expect(wiki_instance.body).to eq my_wiki.body
        end
      end

      describe "PUT update" do
        it "updates wiki with expected attributes" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: { id: my_wiki.id, wiki: { title: new_title, body: new_body } }

          updated_wiki = assigns(:wiki)
          expect(updated_wiki.id).to eq my_wiki.id
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
        end

        it "redirects to the updated wiki" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: { id: my_wiki.id, wiki: { title: new_title, body: new_body } }
          expect(response).to redirect_to my_wiki
        end
      end

      describe "DELETE destroy" do
        it "does not delete the wiki" do
          delete :destroy, params: { id: my_wiki.id }
          count = Wiki.where({id: my_wiki.id}).size
          expect(count).to eq 1
        end

        it "redirects to wiki index" do
          delete :destroy, params: { id: my_wiki.id }
          expect(response).to redirect_to wikis_path
        end
      end
    end
  end

  context "signed in admin user" do
    before do
      sign_in my_user
      my_user.admin!
    end

    describe "GET show" do
      it "returns http success" do
        get :show, params: { id: my_wiki.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the show view" do
        get :show, params: { id: my_wiki.id }
        expect(response).to render_template :show
      end

      it "assigns my_wiki to @wiki" do
        get :show, params: { id: my_wiki.id }
        expect(assigns(:wiki)).to eq(my_wiki)
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new, params: { title: my_wiki.title, body: my_wiki.body, private: my_wiki.private, user: my_wiki.user }
        expect(response).to have_http_status(:success)
      end

      it "renders the new view" do
        get :new, params: { title: my_wiki.title, body: my_wiki.body, private: my_wiki.private, user: my_wiki.user }
        expect(response).to render_template :new
      end

      it "instantiates @wiki" do
        get :new, params: { title: my_wiki.title, body: my_wiki.body, private: my_wiki.private, user: my_wiki.user }
        expect(assigns(:wiki)).not_to be_nil
      end
    end

    describe "POST create public wiki" do
      it "increases the number of Wiki by 1" do
        expect{ post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false} } }.to change(Wiki,:count).by(1)
      end

      it "assigns the new wiki to @wiki" do
        post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false} }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the new wiki" do
        post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false} }
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "POST create private wiki" do
      it "does not allow for a private wiki to be created" do
        expect{ post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true} } }.to change(Wiki, :count).by(1)
      end

      it "assigns the new wiki to @wiki" do
        post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true} }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the new wiki" do
        post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true} }
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, params: { id: my_wiki.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, params: { id: my_wiki.id }
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, params: { id: my_wiki.id }
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq my_wiki.id
        expect(wiki_instance.title).to eq my_wiki.title
        expect(wiki_instance.body).to eq my_wiki.body
      end
    end

    describe "PUT update" do
      it "updates wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: { id: my_wiki.id, wiki: { title: new_title, body: new_body } }

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: { id: my_wiki.id, wiki: { title: new_title, body: new_body } }
        expect(response).to redirect_to my_wiki
      end
    end

    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, params: { id: my_wiki.id }
        count = Wiki.where({id: my_wiki.id}).size
        expect(count).to eq 0
      end

      it "redirects to wiki index" do
        delete :destroy, params: { id: my_wiki.id }
        expect(response).to redirect_to wikis_path
      end
    end

    context "admin user editing not their wiki" do
      before do
        sign_in other_user
        other_user.admin!
      end

      describe "GET edit" do
        it "returns http success" do
          get :edit, params: { id: my_wiki.id }
          expect(response).to have_http_status(:success)
        end

        it "renders the #edit view" do
          get :edit, params: { id: my_wiki.id }
          expect(response).to render_template :edit
        end

        it "assigns wiki to be updated to @wiki" do
          get :edit, params: { id: my_wiki.id }
          wiki_instance = assigns(:wiki)

          expect(wiki_instance.id).to eq my_wiki.id
          expect(wiki_instance.title).to eq my_wiki.title
          expect(wiki_instance.body).to eq my_wiki.body
        end
      end

      describe "PUT update" do
        it "updates wiki with expected attributes" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: { id: my_wiki.id, wiki: { title: new_title, body: new_body } }

          updated_wiki = assigns(:wiki)
          expect(updated_wiki.id).to eq my_wiki.id
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
        end

        it "redirects to the updated wiki" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: { id: my_wiki.id, wiki: { title: new_title, body: new_body } }
          expect(response).to redirect_to my_wiki
        end
      end

      describe "DELETE destroy" do
        it "deletes the wiki" do
          delete :destroy, params: { id: my_wiki.id }
          count = Wiki.where({id: my_wiki.id}).size
          expect(count).to eq 0
        end

        it "redirects to wiki index" do
          delete :destroy, params: { id: my_wiki.id }
          expect(response).to redirect_to wikis_path
        end
      end
    end

  end

  context "signed in premium user" do
    before do
      sign_in my_user
      my_user.premium!
    end

    describe "GET show" do
      it "returns http success" do
        get :show, params: { id: my_wiki.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the show view" do
        get :show, params: { id: my_wiki.id }
        expect(response).to render_template :show
      end

      it "assigns my_wiki to @wiki" do
        get :show, params: { id: my_wiki.id }
        expect(assigns(:wiki)).to eq(my_wiki)
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new, params: { title: my_wiki.title, body: my_wiki.body, private: my_wiki.private, user: my_wiki.user }
        expect(response).to have_http_status(:success)
      end

      it "renders the new view" do
        get :new, params: { title: my_wiki.title, body: my_wiki.body, private: my_wiki.private, user: my_wiki.user }
        expect(response).to render_template :new
      end

      it "instantiates @wiki" do
        get :new, params: { title: my_wiki.title, body: my_wiki.body, private: my_wiki.private, user: my_wiki.user }
        expect(assigns(:wiki)).not_to be_nil
      end
    end

    describe "POST create public wiki" do
      it "increases the number of Wiki by 1" do
        expect{ post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false} } }.to change(Wiki,:count).by(1)
      end

      it "assigns the new wiki to @wiki" do
        post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false} }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the new wiki" do
        post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false} }
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "POST create private wiki" do
      it "does not allow for a private wiki to be created" do
        expect{ post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true} } }.to change(Wiki, :count).by(1)
      end

      it "assigns the new wiki to @wiki" do
        post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true} }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the new wiki" do
        post :create, params: { wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true} }
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, params: { id: my_wiki.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, params: { id: my_wiki.id }
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, params: { id: my_wiki.id }
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq my_wiki.id
        expect(wiki_instance.title).to eq my_wiki.title
        expect(wiki_instance.body).to eq my_wiki.body
      end
    end

    describe "PUT update" do
      it "updates wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: { id: my_wiki.id, wiki: { title: new_title, body: new_body } }

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: { id: my_wiki.id, wiki: { title: new_title, body: new_body } }
        expect(response).to redirect_to my_wiki
      end
    end

    describe "DELETE destroy" do
      it "does not delete the wiki" do
        delete :destroy, params: { id: my_wiki.id }
        count = Wiki.where({id: my_wiki.id}).size
        expect(count).to eq 1
      end

      it "redirects to wiki index" do
        delete :destroy, params: { id: my_wiki.id }
        expect(response).to redirect_to wikis_path
      end
    end

    context "premium user editing not their wiki" do
      before do
        sign_in other_user
        other_user.premium!
      end

      describe "GET edit" do
        it "returns http success" do
          get :edit, params: { id: my_wiki.id }
          expect(response).to have_http_status(:success)
        end

        it "renders the #edit view" do
          get :edit, params: { id: my_wiki.id }
          expect(response).to render_template :edit
        end

        it "assigns wiki to be updated to @wiki" do
          get :edit, params: { id: my_wiki.id }
          wiki_instance = assigns(:wiki)

          expect(wiki_instance.id).to eq my_wiki.id
          expect(wiki_instance.title).to eq my_wiki.title
          expect(wiki_instance.body).to eq my_wiki.body
        end
      end

      describe "PUT update" do
        it "updates wiki with expected attributes" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: { id: my_wiki.id, wiki: { title: new_title, body: new_body } }

          updated_wiki = assigns(:wiki)
          expect(updated_wiki.id).to eq my_wiki.id
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
        end

        it "redirects to the updated wiki" do
          new_title = RandomData.random_sentence
          new_body = RandomData.random_paragraph

          put :update, params: { id: my_wiki.id, wiki: { title: new_title, body: new_body } }
          expect(response).to redirect_to my_wiki
        end
      end

      describe "DELETE destroy" do
        it "does not delete the wiki" do
          delete :destroy, params: { id: my_wiki.id }
          count = Wiki.where({id: my_wiki.id}).size
          expect(count).to eq 1
       end

       it "redirects to wiki index" do
         delete :destroy, params: { id: my_wiki.id }
         expect(response).to redirect_to wikis_path
       end
     end
   end
 end
end
