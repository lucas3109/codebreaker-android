
	// ActionScript file
	import flash.display.Sprite; 
	import flash.filters.BitmapFilterQuality; 
	import flash.filters.GlowFilter; 
	
	// Create a cross graphic. 
	var crossGraphic:Sprite = new Sprite(); 
	//crossGraphic.graphics.lineStyle(); 
	//crossGraphic.graphics.beginFill(0xCCCC00); 
	//crossGraphic.graphics.drawRect(60, 90, 100, 20); 
	//crossGraphic.graphics.drawRect(100, 50, 20, 100); 
	//crossGraphic.graphics.endFill(); 
	//addChild(crossGraphic); 
	
	// Apply the glow filter to the cross shape. 
	public function setGlowFilter(color=0xFFFFFF,alpha=1,blurX=25,blurY=25,quality=BitmapFilterQuality.MEDIUM)
	{
	var glow:GlowFilter = new GlowFilter(); 
	glow.color = color; 
	glow.alpha = alpha; 
	glow.blurX = blurX; 
	glow.blurY = blurY; 
	glow.quality = quality; 
	
	return [glow];
	}
