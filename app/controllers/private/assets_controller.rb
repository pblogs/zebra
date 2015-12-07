class Private::AssetsController < ApplicationController
  def destroy
    asset = Asset.find(params[:id])
    asset.image = nil
    asset.save
    asset.destroy
  end
end
