class BuyController < ApplicationController
  def sale
    @product = params[:product_id]
    @user = params[:user_id]
    result_product = checkProduct(@product)
    result_user = checkUser(@user)
      if result_product.include? "stock" and result_user.include? "firstName"
        options = {
          :body => {
            :product_id => @product,
            :user_id => @user
          }.to_json,
          :headers => {
            'Content-Type' => 'application/json'
          }
      }
      if result_product["stock"] >= 1
      results = HTTParty.post("http://192.168.99.101:3002/sales", options)
      if results.include? "created_at"
        render  plain:"Venta creada satisfactoriamente.", status: 201
        puts "Venta creada satisfactoriamente."
        return updateStock(result_product["id"],restStock(result_product))
      end
      else
        render  plain:"Producto con stock insuficiente.",status: 204
        puts "Producto con stock insuficiente."
        return 1
      end
  else
      render  plain:'Petición incorrecta.',status: 400
      puts 'Petición incorrecta.'
    end
  end

  def restStock (product)
    result = {
      :body => {
        :stock => product["stock"]-1
      }.to_json,
      :headers => {
        'Content-Type' => 'application/json'
      }
  }
    return result

  end
  def updateStock(id,product)
    results = HTTParty.put("http://192.168.99.101:3000/products/" + id.to_s,product)
    return results
  end
  def checkProduct(id)
    results = HTTParty.get("http://192.168.99.101:3000/products/" + id.to_s)
    return results
  end
  def checkUser(id)
    results = HTTParty.get("http://192.168.99.101:3001/users/" + id.to_s)
    return results
  end
  def purchases
      @response = HTTParty.get("http://192.168.99.101:3002/sales/")
      @result = JSON.parse(@response.body)
      @result.delete_if {|key, value| key["user_id"] != params[:id].to_i }
      render json: @result
    end
end
