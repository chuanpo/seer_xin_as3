package gs
{
   import flash.events.*;
   import flash.utils.*;
   import gs.events.TweenEvent;
   import gs.plugins.*;
   import gs.utils.tween.*;
   
   public class TweenMax extends TweenLite implements IEventDispatcher
   {
      public static const version:Number = 10.1;
      
      private static var _activatedPlugins:Boolean = TweenPlugin.activate([TintPlugin,RemoveTintPlugin,FramePlugin,AutoAlphaPlugin,VisiblePlugin,VolumePlugin,EndArrayPlugin,HexColorsPlugin,BlurFilterPlugin,ColorMatrixFilterPlugin,BevelFilterPlugin,DropShadowFilterPlugin,GlowFilterPlugin,RoundPropsPlugin,BezierPlugin,BezierThroughPlugin,ShortRotationPlugin]);
      
      private static var _overwriteMode:int = OverwriteManager.enabled ? OverwriteManager.mode : OverwriteManager.init();
      
      public static var killTweensOf:Function = TweenLite.killTweensOf;
      
      public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
      
      public static var removeTween:Function = TweenLite.removeTween;
      
      protected static var _pausedTweens:Dictionary = new Dictionary(false);
      
      protected static var _globalTimeScale:Number = 1;
      
      protected var _dispatcher:EventDispatcher;
      
      protected var _callbacks:Object;
      
      public var pauseTime:Number;
      
      protected var _repeatCount:Number;
      
      protected var _timeScale:Number;
      
      public function TweenMax($target:Object, $duration:Number, $vars:Object)
      {
         super($target,$duration,$vars);
         if(TweenLite.version < 10.09)
         {
            trace("TweenMax error! Please update your TweenLite class or try deleting your ASO files. TweenMax requires a more recent version. Download updates at http://www.TweenMax.com.");
         }
         if(this.combinedTimeScale != 1 && this.target is TweenMax)
         {
            _timeScale = 1;
            this.combinedTimeScale = _globalTimeScale;
         }
         else
         {
            _timeScale = this.combinedTimeScale;
            this.combinedTimeScale *= _globalTimeScale;
         }
         if(this.combinedTimeScale != 1 && this.delay != 0)
         {
            this.startTime = this.initTime + this.delay * (1000 / this.combinedTimeScale);
         }
         if(this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null)
         {
            initDispatcher();
            if($duration == 0 && this.delay == 0)
            {
               onUpdateDispatcher();
               onCompleteDispatcher();
            }
         }
         _repeatCount = 0;
         if(!isNaN(this.vars.yoyo) || !isNaN(this.vars.loop))
         {
            this.vars.persist = true;
         }
         if(this.delay == 0 && this.exposedVars.startAt != null)
         {
            this.exposedVars.startAt.overwrite = 0;
            new TweenMax(this.target,0,this.exposedVars.startAt);
         }
      }
      
      public static function set globalTimeScale($n:Number) : void
      {
         setGlobalTimeScale($n);
      }
      
      public static function pauseAll($tweens:Boolean = true, $delayedCalls:Boolean = false) : void
      {
         changePause(true,$tweens,$delayedCalls);
      }
      
      public static function killAllDelayedCalls($complete:Boolean = false) : void
      {
         killAll($complete,false,true);
      }
      
      public static function setGlobalTimeScale($scale:Number) : void
      {
         var i:int = 0;
         var a:Array = null;
         if($scale < 0.00001)
         {
            $scale = 0.00001;
         }
         var ml:Dictionary = masterList;
         _globalTimeScale = $scale;
         for each(a in ml)
         {
            for(i = a.length - 1; i > -1; i--)
            {
               if(a[i] is TweenMax)
               {
                  a[i].timeScale *= 1;
               }
            }
         }
      }
      
      public static function get globalTimeScale() : Number
      {
         return _globalTimeScale;
      }
      
      public static function getTweensOf($target:Object) : Array
      {
         var tween:TweenLite = null;
         var i:int = 0;
         var a:Array = masterList[$target];
         var toReturn:Array = [];
         if(a != null)
         {
            for(i = a.length - 1; i > -1; i--)
            {
               if(!a[i].gc)
               {
                  toReturn[toReturn.length] = a[i];
               }
            }
         }
         for each(tween in _pausedTweens)
         {
            if(tween.target == $target)
            {
               toReturn[toReturn.length] = tween;
            }
         }
         return toReturn;
      }
      
      public static function delayedCall($delay:Number, $onComplete:Function, $onCompleteParams:Array = null, $persist:Boolean = false) : TweenMax
      {
         return new TweenMax($onComplete,0,{
            "delay":$delay,
            "onComplete":$onComplete,
            "onCompleteParams":$onCompleteParams,
            "persist":$persist,
            "overwrite":0
         });
      }
      
      public static function isTweening($target:Object) : Boolean
      {
         var a:Array = getTweensOf($target);
         for(var i:int = a.length - 1; i > -1; i--)
         {
            if((a[i].active || a[i].startTime == currentTime) && !a[i].gc)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function changePause($pause:Boolean, $tweens:Boolean = true, $delayedCalls:Boolean = false) : void
      {
         var isDC:Boolean = false;
         var a:Array = getAllTweens();
         for(var i:int = a.length - 1; i > -1; i--)
         {
            isDC = a[i].target == a[i].vars.onComplete;
            if(a[i] is TweenMax && (isDC == $delayedCalls || isDC != $tweens))
            {
               a[i].paused = $pause;
            }
         }
      }
      
      public static function killAllTweens($complete:Boolean = false) : void
      {
         killAll($complete,true,false);
      }
      
      public static function from($target:Object, $duration:Number, $vars:Object) : TweenMax
      {
         $vars.runBackwards = true;
         return new TweenMax($target,$duration,$vars);
      }
      
      public static function killAll($complete:Boolean = false, $tweens:Boolean = true, $delayedCalls:Boolean = true) : void
      {
         var isDC:Boolean = false;
         var i:int = 0;
         var a:Array = getAllTweens();
         for(i = a.length - 1; i > -1; i--)
         {
            isDC = a[i].target == a[i].vars.onComplete;
            if(isDC == $delayedCalls || isDC != $tweens)
            {
               if($complete)
               {
                  a[i].complete(false);
                  a[i].clear();
               }
               else
               {
                  TweenLite.removeTween(a[i],true);
               }
            }
         }
      }
      
      public static function getAllTweens() : Array
      {
         var a:Array = null;
         var i:int = 0;
         var tween:TweenLite = null;
         var ml:Dictionary = masterList;
         var toReturn:Array = [];
         for each(a in ml)
         {
            for(i = a.length - 1; i > -1; i--)
            {
               if(!a[i].gc)
               {
                  toReturn[toReturn.length] = a[i];
               }
            }
         }
         for each(tween in _pausedTweens)
         {
            toReturn[toReturn.length] = tween;
         }
         return toReturn;
      }
      
      public static function resumeAll($tweens:Boolean = true, $delayedCalls:Boolean = false) : void
      {
         changePause(false,$tweens,$delayedCalls);
      }
      
      public static function to($target:Object, $duration:Number, $vars:Object) : TweenMax
      {
         return new TweenMax($target,$duration,$vars);
      }
      
      public function dispatchEvent($e:Event) : Boolean
      {
         if(_dispatcher == null)
         {
            return false;
         }
         return _dispatcher.dispatchEvent($e);
      }
      
      public function get reversed() : Boolean
      {
         return this.ease == reverseEase;
      }
      
      public function set reversed($b:Boolean) : void
      {
         if(this.reversed != $b)
         {
            reverse();
         }
      }
      
      public function get progress() : Number
      {
         var t:Number = !isNaN(this.pauseTime) ? this.pauseTime : currentTime;
         var p:Number = ((t - this.initTime) * 0.001 - this.delay / this.combinedTimeScale) / this.duration * this.combinedTimeScale;
         if(p > 1)
         {
            return 1;
         }
         if(p < 0)
         {
            return 0;
         }
         return p;
      }
      
      override public function set enabled($b:Boolean) : void
      {
         if(!$b)
         {
            _pausedTweens[this] = null;
            delete _pausedTweens[this];
         }
         super.enabled = $b;
         if($b)
         {
            this.combinedTimeScale = _timeScale * _globalTimeScale;
         }
      }
      
      protected function onStartDispatcher(... $args) : void
      {
         if(_callbacks.onStart != null)
         {
            _callbacks.onStart.apply(null,this.vars.onStartParams);
         }
         _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
      }
      
      public function setDestination($property:String, $value:*, $adjustStartValues:Boolean = true) : void
      {
         var i:int = 0;
         var ti:TweenInfo = null;
         var varsOld:Object = null;
         var exposedVarsOld:Object = null;
         var tweensOld:Array = null;
         var hadPlugins:Boolean = false;
         var addedTweens:Array = null;
         var killVars:Object = null;
         var p:Number = this.progress;
         if(this.initted)
         {
            if(!$adjustStartValues)
            {
               for(i = this.tweens.length - 1; i > -1; i--)
               {
                  ti = this.tweens[i];
                  if(ti.name == $property)
                  {
                     ti.target[ti.property] = ti.start;
                  }
               }
            }
            varsOld = this.vars;
            exposedVarsOld = this.exposedVars;
            tweensOld = this.tweens;
            hadPlugins = _hasPlugins;
            this.tweens = [];
            this.vars = this.exposedVars = {};
            this.vars[$property] = $value;
            initTweenVals();
            if(this.ease != reverseEase && varsOld.ease is Function)
            {
               this.ease = varsOld.ease;
            }
            if($adjustStartValues && p != 0)
            {
               adjustStartValues();
            }
            addedTweens = this.tweens;
            this.vars = varsOld;
            this.exposedVars = exposedVarsOld;
            this.tweens = tweensOld;
            killVars = {};
            killVars[$property] = true;
            for(i = this.tweens.length - 1; i > -1; i--)
            {
               ti = this.tweens[i];
               if(ti.name == $property)
               {
                  this.tweens.splice(i,1);
               }
               else if(ti.isPlugin && ti.name == "_MULTIPLE_")
               {
                  ti.target.killProps(killVars);
                  if(ti.target.overwriteProps.length == 0)
                  {
                     this.tweens.splice(i,1);
                  }
               }
            }
            this.tweens = this.tweens.concat(addedTweens);
            _hasPlugins = Boolean(hadPlugins || _hasPlugins);
         }
         this.vars[$property] = this.exposedVars[$property] = $value;
      }
      
      override public function initTweenVals() : void
      {
         var i:int = 0;
         var j:int = 0;
         var prop:String = null;
         var multiProps:String = null;
         var rp:Array = null;
         var plugin:Object = null;
         var ti:TweenInfo = null;
         if(this.exposedVars.startAt != null && this.delay != 0)
         {
            this.exposedVars.startAt.overwrite = 0;
            new TweenMax(this.target,0,this.exposedVars.startAt);
         }
         super.initTweenVals();
         if(this.exposedVars.roundProps is Array && TweenLite.plugins.roundProps != null)
         {
            rp = this.exposedVars.roundProps;
            for(i = rp.length - 1; i > -1; i--)
            {
               prop = rp[i];
               for(j = this.tweens.length - 1; j > -1; j--)
               {
                  ti = this.tweens[j];
                  if(ti.name == prop)
                  {
                     if(ti.isPlugin)
                     {
                        ti.target.round = true;
                     }
                     else if(plugin == null)
                     {
                        plugin = new TweenLite.plugins.roundProps();
                        plugin.add(ti.target,prop,ti.start,ti.change);
                        _hasPlugins = true;
                        this.tweens[j] = new TweenInfo(plugin,"changeFactor",0,1,prop,true);
                     }
                     else
                     {
                        plugin.add(ti.target,prop,ti.start,ti.change);
                        this.tweens.splice(j,1);
                     }
                  }
                  else if(ti.isPlugin && ti.name == "_MULTIPLE_" && !ti.target.round)
                  {
                     multiProps = " " + ti.target.overwriteProps.join(" ") + " ";
                     if(multiProps.indexOf(" " + prop + " ") != -1)
                     {
                        ti.target.round = true;
                     }
                  }
               }
            }
         }
      }
      
      public function restart($includeDelay:Boolean = false) : void
      {
         if($includeDelay)
         {
            this.initTime = currentTime;
            this.startTime = currentTime + this.delay * (1000 / this.combinedTimeScale);
         }
         else
         {
            this.startTime = currentTime;
            this.initTime = currentTime - this.delay * (1000 / this.combinedTimeScale);
         }
         _repeatCount = 0;
         if(this.target != this.vars.onComplete)
         {
            render(this.startTime);
         }
         this.pauseTime = NaN;
         _pausedTweens[this] = null;
         delete _pausedTweens[this];
         this.enabled = true;
      }
      
      public function removeEventListener($type:String, $listener:Function, $useCapture:Boolean = false) : void
      {
         if(_dispatcher != null)
         {
            _dispatcher.removeEventListener($type,$listener,$useCapture);
         }
      }
      
      public function addEventListener($type:String, $listener:Function, $useCapture:Boolean = false, $priority:int = 0, $useWeakReference:Boolean = false) : void
      {
         if(_dispatcher == null)
         {
            initDispatcher();
         }
         if($type == TweenEvent.UPDATE && this.vars.onUpdate != onUpdateDispatcher)
         {
            this.vars.onUpdate = onUpdateDispatcher;
            _hasUpdate = true;
         }
         _dispatcher.addEventListener($type,$listener,$useCapture,$priority,$useWeakReference);
      }
      
      protected function adjustStartValues() : void
      {
         var factor:Number = NaN;
         var inv:Number = NaN;
         var endValue:Number = NaN;
         var ti:TweenInfo = null;
         var i:int = 0;
         var p:Number = this.progress;
         if(p != 0)
         {
            factor = this.ease(p,0,1,1);
            inv = 1 / (1 - factor);
            for(i = this.tweens.length - 1; i > -1; i--)
            {
               ti = this.tweens[i];
               endValue = ti.start + ti.change;
               if(ti.isPlugin)
               {
                  ti.change = (endValue - factor) * inv;
               }
               else
               {
                  ti.change = (endValue - ti.target[ti.property]) * inv;
               }
               ti.start = endValue - ti.change;
            }
         }
      }
      
      override public function render($t:uint) : void
      {
         var factor:Number = NaN;
         var ti:TweenInfo = null;
         var i:int = 0;
         var time:Number = ($t - this.startTime) * 0.001 * this.combinedTimeScale;
         if(time >= this.duration)
         {
            time = this.duration;
            factor = this.ease == this.vars.ease || this.duration == 0.001 ? 1 : 0;
         }
         else
         {
            factor = this.ease(time,0,1,this.duration);
         }
         for(i = this.tweens.length - 1; i > -1; i--)
         {
            ti = this.tweens[i];
            ti.target[ti.property] = ti.start + factor * ti.change;
         }
         if(_hasUpdate)
         {
            this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         if(time == this.duration)
         {
            complete(true);
         }
      }
      
      protected function initDispatcher() : void
      {
         var v:Object = null;
         var p:String = null;
         if(_dispatcher == null)
         {
            _dispatcher = new EventDispatcher(this);
            _callbacks = {
               "onStart":this.vars.onStart,
               "onUpdate":this.vars.onUpdate,
               "onComplete":this.vars.onComplete
            };
            if(this.vars.isTV == true)
            {
               this.vars = this.vars.clone();
            }
            else
            {
               v = {};
               for(p in this.vars)
               {
                  v[p] = this.vars[p];
               }
               this.vars = v;
            }
            this.vars.onStart = onStartDispatcher;
            this.vars.onComplete = onCompleteDispatcher;
            if(this.vars.onStartListener is Function)
            {
               _dispatcher.addEventListener(TweenEvent.START,this.vars.onStartListener,false,0,true);
            }
            if(this.vars.onUpdateListener is Function)
            {
               _dispatcher.addEventListener(TweenEvent.UPDATE,this.vars.onUpdateListener,false,0,true);
               this.vars.onUpdate = onUpdateDispatcher;
               _hasUpdate = true;
            }
            if(this.vars.onCompleteListener is Function)
            {
               _dispatcher.addEventListener(TweenEvent.COMPLETE,this.vars.onCompleteListener,false,0,true);
            }
         }
      }
      
      public function willTrigger($type:String) : Boolean
      {
         if(_dispatcher == null)
         {
            return false;
         }
         return _dispatcher.willTrigger($type);
      }
      
      public function set progress($n:Number) : void
      {
         this.startTime = currentTime - this.duration * $n * 1000;
         this.initTime = this.startTime - this.delay * (1000 / this.combinedTimeScale);
         if(!this.started)
         {
            activate();
         }
         render(currentTime);
         if(!isNaN(this.pauseTime))
         {
            this.pauseTime = currentTime;
            this.startTime = 999999999999999;
            this.active = false;
         }
      }
      
      public function reverse($adjustDuration:Boolean = true, $forcePlay:Boolean = true) : void
      {
         this.ease = this.vars.ease == this.ease ? reverseEase : this.vars.ease;
         var p:Number = this.progress;
         if($adjustDuration && p > 0)
         {
            this.startTime = currentTime - (1 - p) * this.duration * 1000 / this.combinedTimeScale;
            this.initTime = this.startTime - this.delay * (1000 / this.combinedTimeScale);
         }
         if($forcePlay != false)
         {
            if(p < 1)
            {
               resume();
            }
            else
            {
               restart();
            }
         }
      }
      
      protected function onUpdateDispatcher(... $args) : void
      {
         if(_callbacks.onUpdate != null)
         {
            _callbacks.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
      }
      
      public function set paused($b:Boolean) : void
      {
         if($b)
         {
            pause();
         }
         else
         {
            resume();
         }
      }
      
      public function resume() : void
      {
         this.enabled = true;
         if(!isNaN(this.pauseTime))
         {
            this.initTime += currentTime - this.pauseTime;
            this.startTime = this.initTime + this.delay * (1000 / this.combinedTimeScale);
            this.pauseTime = NaN;
            if(!this.started && currentTime >= this.startTime)
            {
               activate();
            }
            else
            {
               this.active = this.started;
            }
            _pausedTweens[this] = null;
            delete _pausedTweens[this];
         }
      }
      
      public function get paused() : Boolean
      {
         return !isNaN(this.pauseTime);
      }
      
      public function reverseEase($t:Number, $b:Number, $c:Number, $d:Number) : Number
      {
         return this.vars.ease($d - $t,$b,$c,$d);
      }
      
      public function killProperties($names:Array) : void
      {
         var i:int = 0;
         var v:Object = {};
         for(i = $names.length - 1; i > -1; i--)
         {
            v[$names[i]] = true;
         }
         killVars(v);
      }
      
      public function hasEventListener($type:String) : Boolean
      {
         if(_dispatcher == null)
         {
            return false;
         }
         return _dispatcher.hasEventListener($type);
      }
      
      public function pause() : void
      {
         if(isNaN(this.pauseTime))
         {
            this.pauseTime = currentTime;
            this.startTime = 999999999999999;
            this.enabled = false;
            _pausedTweens[this] = this;
         }
      }
      
      override public function complete($skipRender:Boolean = false) : void
      {
         if(!isNaN(this.vars.yoyo) && (_repeatCount < this.vars.yoyo || this.vars.yoyo == 0) || !isNaN(this.vars.loop) && (_repeatCount < this.vars.loop || this.vars.loop == 0))
         {
            ++_repeatCount;
            if(!isNaN(this.vars.yoyo))
            {
               this.ease = this.vars.ease == this.ease ? reverseEase : this.vars.ease;
            }
            this.startTime = $skipRender ? this.startTime + this.duration * (1000 / this.combinedTimeScale) : currentTime;
            this.initTime = this.startTime - this.delay * (1000 / this.combinedTimeScale);
         }
         else if(this.vars.persist == true)
         {
            pause();
         }
         super.complete($skipRender);
      }
      
      public function set timeScale($n:Number) : void
      {
         if($n < 0.00001)
         {
            _timeScale = 0.00001;
            $n = 0.00001;
         }
         else
         {
            _timeScale = $n;
            $n *= _globalTimeScale;
         }
         this.initTime = currentTime - (currentTime - this.initTime - this.delay * (1000 / this.combinedTimeScale)) * this.combinedTimeScale * (1 / $n) - this.delay * (1000 / $n);
         if(this.startTime != 999999999999999)
         {
            this.startTime = this.initTime + this.delay * (1000 / $n);
         }
         this.combinedTimeScale = $n;
      }
      
      public function invalidate($adjustStartValues:Boolean = true) : void
      {
         var p:Number = NaN;
         if(this.initted)
         {
            p = this.progress;
            if(!$adjustStartValues && p != 0)
            {
               this.progress = 0;
            }
            this.tweens = [];
            _hasPlugins = false;
            this.exposedVars = this.vars.isTV == true ? this.vars.exposedProps : this.vars;
            initTweenVals();
            _timeScale = Number(this.vars.timeScale) || 1;
            this.combinedTimeScale = _timeScale * _globalTimeScale;
            this.delay = Number(this.vars.delay) || 0;
            if(isNaN(this.pauseTime))
            {
               this.startTime = this.initTime + this.delay * 1000 / this.combinedTimeScale;
            }
            if(this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null)
            {
               if(_dispatcher != null)
               {
                  this.vars.onStart = _callbacks.onStart;
                  this.vars.onUpdate = _callbacks.onUpdate;
                  this.vars.onComplete = _callbacks.onComplete;
                  _dispatcher = null;
               }
               initDispatcher();
            }
            if(p != 0)
            {
               if($adjustStartValues)
               {
                  adjustStartValues();
               }
               else
               {
                  this.progress = p;
               }
            }
         }
      }
      
      public function get timeScale() : Number
      {
         return _timeScale;
      }
      
      protected function onCompleteDispatcher(... $args) : void
      {
         if(_callbacks.onComplete != null)
         {
            _callbacks.onComplete.apply(null,this.vars.onCompleteParams);
         }
         _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
      }
   }
}

