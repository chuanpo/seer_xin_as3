package com.oaxoa.fx
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class Lightning extends Sprite
   {
      private const SMOOTH_COLOR:uint = 8421504;
      
      private var holder:Sprite;
      
      private var sbd:BitmapData;
      
      private var bbd:BitmapData;
      
      private var soffs:Array;
      
      private var boffs:Array;
      
      private var glow:GlowFilter;
      
      public var lifeSpan:Number;
      
      private var lifeTimer:Timer;
      
      public var startX:Number;
      
      public var startY:Number;
      
      public var endX:Number;
      
      public var endY:Number;
      
      public var len:Number;
      
      public var multi:Number;
      
      public var multi2:Number;
      
      public var _steps:uint;
      
      public var stepEvery:Number;
      
      private var seed1:uint;
      
      private var seed2:uint;
      
      public var smooth:Sprite;
      
      public var childrenSmooth:Sprite;
      
      public var childrenArray:Array = [];
      
      public var _smoothPercentage:uint = 50;
      
      public var _childrenSmoothPercentage:uint;
      
      public var _color:uint;
      
      private var generation:uint;
      
      private var _childrenMaxGenerations:uint = 3;
      
      private var _childrenProbability:Number = 0.025;
      
      private var _childrenProbabilityDecay:Number = 0;
      
      private var _childrenMaxCount:uint = 4;
      
      private var _childrenMaxCountDecay:Number = 0.5;
      
      private var _childrenLengthDecay:Number = 0;
      
      private var _childrenAngleVariation:Number = 60;
      
      private var _childrenLifeSpanMin:Number = 0;
      
      private var _childrenLifeSpanMax:Number = 0;
      
      private var _childrenDetachedEnd:Boolean = false;
      
      private var _maxLength:Number = 0;
      
      private var _maxLengthVary:Number = 0;
      
      public var _isVisible:Boolean = true;
      
      public var _alphaFade:Boolean = true;
      
      public var parentInstance:Lightning;
      
      private var _thickness:Number;
      
      private var _thicknessDecay:Number;
      
      private var initialized:Boolean = false;
      
      private var _wavelength:Number = 0.3;
      
      private var _amplitude:Number = 0.5;
      
      private var _speed:Number = 1;
      
      private var calculatedWavelength:Number;
      
      private var calculatedSpeed:Number;
      
      public var alphaFadeType:String;
      
      public var thicknessFadeType:String;
      
      private var position:Number = 0;
      
      private var absolutePosition:Number = 1;
      
      private var dx:Number;
      
      private var dy:Number;
      
      private var soff:Number;
      
      private var soffx:Number;
      
      private var soffy:Number;
      
      private var boff:Number;
      
      private var boffx:Number;
      
      private var boffy:Number;
      
      private var angle:Number;
      
      private var tx:Number;
      
      private var ty:Number;
      
      public function Lightning(pcolor:uint = 16777215, pthickness:Number = 2, pgeneration:uint = 0)
      {
         super();
         mouseEnabled = false;
         this._color = pcolor;
         this._thickness = pthickness;
         this.alphaFadeType = LightningFadeType.GENERATION;
         this.thicknessFadeType = LightningFadeType.NONE;
         this.generation = pgeneration;
         if(this.generation == 0)
         {
            this.init();
         }
      }
      
      private function init() : void
      {
         this.randomizeSeeds();
         if(this.lifeSpan > 0)
         {
            this.startLifeTimer();
         }
         this.multi2 = 0.03;
         this.holder = new Sprite();
         this.holder.mouseEnabled = false;
         this.startX = 50;
         this.startY = 200;
         this.endX = 50;
         this.endY = 600;
         this.stepEvery = 4;
         this._steps = 50;
         this.sbd = new BitmapData(this._steps,1,false);
         this.bbd = new BitmapData(this._steps,1,false);
         this.soffs = [new Point(0,0),new Point(0,0)];
         this.boffs = [new Point(0,0),new Point(0,0)];
         if(this.generation == 0)
         {
            this.smooth = new Sprite();
            this.childrenSmooth = new Sprite();
            this.smoothPercentage = 50;
            this.childrenSmoothPercentage = 50;
         }
         else
         {
            this.smooth = this.childrenSmooth = this.parentInstance.childrenSmooth;
         }
         this.steps = 100;
         this.childrenLengthDecay = 0.5;
         addChild(this.holder);
         this.initialized = true;
      }
      
      private function randomizeSeeds() : void
      {
         this.seed1 = Math.random() * 100;
         this.seed2 = Math.random() * 100;
      }
      
      public function set steps(arg:uint) : void
      {
         if(arg < 2)
         {
            arg = 2;
         }
         if(arg > 2880)
         {
            arg = 2880;
         }
         this._steps = arg;
         this.sbd = new BitmapData(this._steps,1,false);
         this.bbd = new BitmapData(this._steps,1,false);
         if(this.generation == 0)
         {
            this.smoothPercentage = this.smoothPercentage;
         }
      }
      
      public function get steps() : uint
      {
         return this._steps;
      }
      
      public function startLifeTimer() : void
      {
         this.lifeTimer = new Timer(this.lifeSpan * 1000,1);
         this.lifeTimer.start();
         this.lifeTimer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         this.kill();
      }
      
      public function kill() : void
      {
         var count:uint = 0;
         var par:Lightning = null;
         var obj:Object = null;
         this.killAllChildren();
         if(Boolean(this.lifeTimer))
         {
            this.lifeTimer.removeEventListener(TimerEvent.TIMER,this.kill);
            this.lifeTimer.stop();
         }
         if(this.parentInstance != null)
         {
            count = 0;
            par = this.parent as Lightning;
            for each(obj in par.childrenArray)
            {
               if(obj.instance == this)
               {
                  par.childrenArray.splice(count,1);
               }
               count++;
            }
         }
         this.parent.removeChild(this);
         delete global[this];
      }
      
      public function killAllChildren() : void
      {
         var child:Lightning = null;
         while(this.childrenArray.length > 0)
         {
            child = this.childrenArray[0].instance;
            child.kill();
         }
      }
      
      public function generateChild(n:uint = 1, recursive:Boolean = false) : void
      {
         var targetChildSteps:uint = 0;
         var i:uint = 0;
         var startStep:uint = 0;
         var endStep:uint = 0;
         var childAngle:Number = NaN;
         var child:Lightning = null;
         if(this.generation < this.childrenMaxGenerations && this.childrenArray.length < this.childrenMaxCount)
         {
            targetChildSteps = this.steps * this.childrenLengthDecay;
            if(targetChildSteps >= 2)
            {
               for(i = 0; i < n; i++)
               {
                  startStep = Math.random() * this.steps;
                  for(endStep = Math.random() * this.steps; endStep == startStep; )
                  {
                     endStep = Math.random() * this.steps;
                  }
                  childAngle = Math.random() * this.childrenAngleVariation - this.childrenAngleVariation / 2;
                  child = new Lightning(this.color,this.thickness,this.generation + 1);
                  child.parentInstance = this;
                  child.lifeSpan = Math.random() * (this.childrenLifeSpanMax - this.childrenLifeSpanMin) + this.childrenLifeSpanMin;
                  child.position = 1 - startStep / this.steps;
                  child.absolutePosition = this.absolutePosition * child.position;
                  child.alphaFadeType = this.alphaFadeType;
                  child.thicknessFadeType = this.thicknessFadeType;
                  if(this.alphaFadeType == LightningFadeType.GENERATION)
                  {
                     child.alpha = 1 - 1 / (this.childrenMaxGenerations + 1) * child.generation;
                  }
                  if(this.thicknessFadeType == LightningFadeType.GENERATION)
                  {
                     child.thickness = this.thickness - this.thickness / (this.childrenMaxGenerations + 1) * child.generation;
                  }
                  child.childrenMaxGenerations = this.childrenMaxGenerations;
                  child.childrenMaxCount = this.childrenMaxCount * (1 - this.childrenMaxCountDecay);
                  child.childrenProbability = this.childrenProbability * (1 - this.childrenProbabilityDecay);
                  child.childrenProbabilityDecay = this.childrenProbabilityDecay;
                  child.childrenLengthDecay = this.childrenLengthDecay;
                  child.childrenDetachedEnd = this.childrenDetachedEnd;
                  child.wavelength = this.wavelength;
                  child.amplitude = this.amplitude;
                  child.speed = this.speed;
                  child.init();
                  this.childrenArray.push({
                     "instance":child,
                     "startStep":startStep,
                     "endStep":endStep,
                     "detachedEnd":this.childrenDetachedEnd,
                     "childAngle":childAngle
                  });
                  addChild(child);
                  child.steps = this.steps * (1 - this.childrenLengthDecay);
                  if(recursive)
                  {
                     child.generateChild(n,true);
                  }
               }
            }
         }
      }
      
      public function update() : void
      {
         var generateChildRandom:Number = NaN;
         var childObject:Object = null;
         var drawMatrix:Matrix = null;
         var isVisibleProbability:Number = NaN;
         if(this.initialized)
         {
            this.dx = this.endX - this.startX;
            this.dy = this.endY - this.startY;
            this.len = Math.sqrt(this.dx * this.dx + this.dy * this.dy);
            this.soffs[0].x += this.steps / 100 * this.speed;
            this.soffs[0].y += this.steps / 100 * this.speed;
            this.sbd.perlinNoise(this.steps / 20,this.steps / 20,1,this.seed1,false,true,7,true,this.soffs);
            this.calculatedWavelength = this.steps * this.wavelength;
            this.calculatedSpeed = this.calculatedWavelength * 0.1 * this.speed;
            this.boffs[0].x -= this.calculatedSpeed;
            this.boffs[0].y += this.calculatedSpeed;
            this.bbd.perlinNoise(this.calculatedWavelength,this.calculatedWavelength,1,this.seed2,false,true,7,true,this.boffs);
            if(this.smoothPercentage > 0)
            {
               drawMatrix = new Matrix();
               drawMatrix.scale(this.steps / this.smooth.width,1);
               this.bbd.draw(this.smooth,drawMatrix);
            }
            if(this.parentInstance != null)
            {
               this.isVisible = this.parentInstance.isVisible;
            }
            else if(this.maxLength == 0)
            {
               this.isVisible = true;
            }
            else
            {
               if(this.len <= this.maxLength)
               {
                  isVisibleProbability = 1;
               }
               else if(this.len > this.maxLength + this.maxLengthVary)
               {
                  isVisibleProbability = 0;
               }
               else
               {
                  isVisibleProbability = 1 - (this.len - this.maxLength) / this.maxLengthVary;
               }
               this.isVisible = Math.random() < isVisibleProbability ? true : false;
            }
            generateChildRandom = Math.random();
            if(generateChildRandom < this.childrenProbability)
            {
               this.generateChild();
            }
            if(this.isVisible)
            {
               this.render();
            }
            for each(childObject in this.childrenArray)
            {
               childObject.instance.update();
            }
         }
      }
      
      public function render() : void
      {
         var childObject:Object = null;
         var currentPosition:Number = NaN;
         var relAlpha:Number = NaN;
         var relThickness:Number = NaN;
         var arad:Number = NaN;
         var childLength:Number = NaN;
         this.holder.graphics.clear();
         this.holder.graphics.lineStyle(this.thickness,this._color);
         this.angle = Math.atan2(this.endY - this.startY,this.endX - this.startX);
         for(var i:uint = 0; i < this.steps; i++)
         {
            currentPosition = 1 / this.steps * (this.steps - i);
            relAlpha = 1;
            relThickness = this.thickness;
            if(this.alphaFadeType == LightningFadeType.TIP_TO_END)
            {
               relAlpha = this.absolutePosition * currentPosition;
            }
            if(this.thicknessFadeType == LightningFadeType.TIP_TO_END)
            {
               relThickness = this.thickness * (this.absolutePosition * currentPosition);
            }
            if(this.alphaFadeType == LightningFadeType.TIP_TO_END || this.thicknessFadeType == LightningFadeType.TIP_TO_END)
            {
               this.holder.graphics.lineStyle(int(relThickness),this._color,relAlpha);
            }
            this.soff = (this.sbd.getPixel(i,0) - 8421504) / 16777215 * this.len * this.multi2;
            this.soffx = Math.sin(this.angle) * this.soff;
            this.soffy = Math.cos(this.angle) * this.soff;
            this.boff = (this.bbd.getPixel(i,0) - 8421504) / 16777215 * this.len * this.amplitude;
            this.boffx = Math.sin(this.angle) * this.boff;
            this.boffy = Math.cos(this.angle) * this.boff;
            this.tx = this.startX + this.dx / (this.steps - 1) * i + this.soffx + this.boffx;
            this.ty = this.startY + this.dy / (this.steps - 1) * i - this.soffy - this.boffy;
            if(i == 0)
            {
               this.holder.graphics.moveTo(this.tx,this.ty);
            }
            this.holder.graphics.lineTo(this.tx,this.ty);
            for each(childObject in this.childrenArray)
            {
               if(childObject.startStep == i)
               {
                  childObject.instance.startX = this.tx;
                  childObject.instance.startY = this.ty;
               }
               if(Boolean(childObject.detachedEnd))
               {
                  arad = this.angle + childObject.childAngle / 180 * Math.PI;
                  childLength = this.len * this.childrenLengthDecay;
                  childObject.instance.endX = childObject.instance.startX + Math.cos(arad) * childLength;
                  childObject.instance.endY = childObject.instance.startY + Math.sin(arad) * childLength;
               }
               else if(childObject.endStep == i)
               {
                  childObject.instance.endX = this.tx;
                  childObject.instance.endY = this.ty;
               }
            }
         }
      }
      
      public function killSurplus() : void
      {
         var child:Lightning = null;
         while(this.childrenArray.length > this.childrenMaxCount)
         {
            child = this.childrenArray[this.childrenArray.length - 1].instance;
            child.kill();
         }
      }
      
      public function set smoothPercentage(arg:Number) : void
      {
         var smoothmatrix:Matrix = null;
         var ratioOffset:uint = 0;
         if(Boolean(this.smooth))
         {
            this._smoothPercentage = arg;
            smoothmatrix = new Matrix();
            smoothmatrix.createGradientBox(this.steps,1);
            ratioOffset = this._smoothPercentage / 100 * 128;
            this.smooth.graphics.clear();
            this.smooth.graphics.beginGradientFill("linear",[this.SMOOTH_COLOR,this.SMOOTH_COLOR,this.SMOOTH_COLOR,this.SMOOTH_COLOR],[1,0,0,1],[0,ratioOffset,255 - ratioOffset,255],smoothmatrix);
            this.smooth.graphics.drawRect(0,0,this.steps,1);
            this.smooth.graphics.endFill();
         }
      }
      
      public function set childrenSmoothPercentage(arg:Number) : void
      {
         this._childrenSmoothPercentage = arg;
         var smoothmatrix:Matrix = new Matrix();
         smoothmatrix.createGradientBox(this.steps,1);
         var ratioOffset:uint = this._childrenSmoothPercentage / 100 * 128;
         this.childrenSmooth.graphics.clear();
         this.childrenSmooth.graphics.beginGradientFill("linear",[this.SMOOTH_COLOR,this.SMOOTH_COLOR,this.SMOOTH_COLOR,this.SMOOTH_COLOR],[1,0,0,1],[0,ratioOffset,255 - ratioOffset,255],smoothmatrix);
         this.childrenSmooth.graphics.drawRect(0,0,this.steps,1);
         this.childrenSmooth.graphics.endFill();
      }
      
      public function get smoothPercentage() : Number
      {
         return this._smoothPercentage;
      }
      
      public function get childrenSmoothPercentage() : Number
      {
         return this._childrenSmoothPercentage;
      }
      
      public function set color(arg:uint) : void
      {
         var child:Object = null;
         this._color = arg;
         this.glow.color = arg;
         this.holder.filters = [this.glow];
         for each(child in this.childrenArray)
         {
            child.instance.color = arg;
         }
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set childrenProbability(arg:Number) : void
      {
         if(arg > 1)
         {
            arg = 1;
         }
         else if(arg < 0)
         {
            arg = 0;
         }
         this._childrenProbability = arg;
      }
      
      public function get childrenProbability() : Number
      {
         return this._childrenProbability;
      }
      
      public function set childrenProbabilityDecay(arg:Number) : void
      {
         if(arg > 1)
         {
            arg = 1;
         }
         else if(arg < 0)
         {
            arg = 0;
         }
         this._childrenProbabilityDecay = arg;
      }
      
      public function get childrenProbabilityDecay() : Number
      {
         return this._childrenProbabilityDecay;
      }
      
      public function set maxLength(arg:Number) : void
      {
         this._maxLength = arg;
      }
      
      public function get maxLength() : Number
      {
         return this._maxLength;
      }
      
      public function set maxLengthVary(arg:Number) : void
      {
         this._maxLengthVary = arg;
      }
      
      public function get maxLengthVary() : Number
      {
         return this._maxLengthVary;
      }
      
      public function set thickness(arg:Number) : void
      {
         if(arg < 0)
         {
            arg = 0;
         }
         this._thickness = arg;
      }
      
      public function get thickness() : Number
      {
         return this._thickness;
      }
      
      public function set thicknessDecay(arg:Number) : void
      {
         if(arg > 1)
         {
            arg = 1;
         }
         else if(arg < 0)
         {
            arg = 0;
         }
         this._thicknessDecay = arg;
      }
      
      public function get thicknessDecay() : Number
      {
         return this._thicknessDecay;
      }
      
      public function set childrenLengthDecay(arg:Number) : void
      {
         if(arg > 1)
         {
            arg = 1;
         }
         else if(arg < 0)
         {
            arg = 0;
         }
         this._childrenLengthDecay = arg;
      }
      
      public function get childrenLengthDecay() : Number
      {
         return this._childrenLengthDecay;
      }
      
      public function set childrenMaxGenerations(arg:uint) : void
      {
         this._childrenMaxGenerations = arg;
         this.killSurplus();
      }
      
      public function get childrenMaxGenerations() : uint
      {
         return this._childrenMaxGenerations;
      }
      
      public function set childrenMaxCount(arg:uint) : void
      {
         this._childrenMaxCount = arg;
         this.killSurplus();
      }
      
      public function get childrenMaxCount() : uint
      {
         return this._childrenMaxCount;
      }
      
      public function set childrenMaxCountDecay(arg:Number) : void
      {
         if(arg > 1)
         {
            arg = 1;
         }
         else if(arg < 0)
         {
            arg = 0;
         }
         this._childrenMaxCountDecay = arg;
      }
      
      public function get childrenMaxCountDecay() : Number
      {
         return this._childrenMaxCountDecay;
      }
      
      public function set childrenAngleVariation(arg:Number) : void
      {
         var o:Object = null;
         this._childrenAngleVariation = arg;
         for each(o in this.childrenArray)
         {
            o.childAngle = Math.random() * arg - arg / 2;
            o.instance.childrenAngleVariation = arg;
         }
      }
      
      public function get childrenAngleVariation() : Number
      {
         return this._childrenAngleVariation;
      }
      
      public function set childrenLifeSpanMin(arg:Number) : void
      {
         this._childrenLifeSpanMin = arg;
      }
      
      public function get childrenLifeSpanMin() : Number
      {
         return this._childrenLifeSpanMin;
      }
      
      public function set childrenLifeSpanMax(arg:Number) : void
      {
         this._childrenLifeSpanMax = arg;
      }
      
      public function get childrenLifeSpanMax() : Number
      {
         return this._childrenLifeSpanMax;
      }
      
      public function set childrenDetachedEnd(arg:Boolean) : void
      {
         this._childrenDetachedEnd = arg;
      }
      
      public function get childrenDetachedEnd() : Boolean
      {
         return this._childrenDetachedEnd;
      }
      
      public function set wavelength(arg:Number) : void
      {
         var o:Object = null;
         this._wavelength = arg;
         for each(o in this.childrenArray)
         {
            o.instance.wavelength = arg;
         }
      }
      
      public function get wavelength() : Number
      {
         return this._wavelength;
      }
      
      public function set amplitude(arg:Number) : void
      {
         var o:Object = null;
         this._amplitude = arg;
         for each(o in this.childrenArray)
         {
            o.instance.amplitude = arg;
         }
      }
      
      public function get amplitude() : Number
      {
         return this._amplitude;
      }
      
      public function set speed(arg:Number) : void
      {
         var o:Object = null;
         this._speed = arg;
         for each(o in this.childrenArray)
         {
            o.instance.speed = arg;
         }
      }
      
      public function get speed() : Number
      {
         return this._speed;
      }
      
      public function set isVisible(arg:Boolean) : void
      {
         this._isVisible = visible = arg;
      }
      
      public function get isVisible() : Boolean
      {
         return this._isVisible;
      }
   }
}

