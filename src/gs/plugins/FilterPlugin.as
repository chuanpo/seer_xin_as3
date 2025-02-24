package gs.plugins
{
   import flash.display.*;
   import flash.filters.*;
   import gs.*;
   import gs.utils.tween.TweenInfo;
   
   public class FilterPlugin extends TweenPlugin
   {
      public static const VERSION:Number = 1.03;
      
      public static const API:Number = 1;
      
      protected var _remove:Boolean;
      
      protected var _target:Object;
      
      protected var _index:int;
      
      protected var _filter:BitmapFilter;
      
      protected var _type:Class;
      
      public function FilterPlugin()
      {
         super();
      }
      
      public function onCompleteTween() : void
      {
         var i:int = 0;
         var filters:Array = null;
         if(_remove)
         {
            filters = _target.filters;
            if(!(filters[_index] is _type))
            {
               for(i = filters.length - 1; i > -1; i--)
               {
                  if(filters[i] is _type)
                  {
                     filters.splice(i,1);
                     break;
                  }
               }
            }
            else
            {
               filters.splice(_index,1);
            }
            _target.filters = filters;
         }
      }
      
      protected function initFilter($props:Object, $default:BitmapFilter) : void
      {
         var p:String = null;
         var i:int = 0;
         var colorTween:HexColorsPlugin = null;
         var filters:Array = _target.filters;
         _index = -1;
         if($props.index != null)
         {
            _index = $props.index;
         }
         else
         {
            for(i = filters.length - 1; i > -1; i--)
            {
               if(filters[i] is _type)
               {
                  _index = i;
                  break;
               }
            }
         }
         if(_index == -1 || filters[_index] == null || $props.addFilter == true)
         {
            _index = $props.index != null ? int($props.index) : int(filters.length);
            filters[_index] = $default;
            _target.filters = filters;
         }
         _filter = filters[_index];
         _remove = Boolean($props.remove == true);
         if(_remove)
         {
            this.onComplete = onCompleteTween;
         }
         var props:Object = $props.isTV == true ? $props.exposedVars : $props;
         for(p in props)
         {
            if(!(!(p in _filter) || _filter[p] == props[p] || p == "remove" || p == "index" || p == "addFilter"))
            {
               if(p == "color" || p == "highlightColor" || p == "shadowColor")
               {
                  colorTween = new HexColorsPlugin();
                  colorTween.initColor(_filter,p,_filter[p],props[p]);
                  _tweens[_tweens.length] = new TweenInfo(colorTween,"changeFactor",0,1,p,false);
               }
               else if(p == "quality" || p == "inner" || p == "knockout" || p == "hideObject")
               {
                  _filter[p] = props[p];
               }
               else
               {
                  addTween(_filter,p,_filter[p],props[p],p);
               }
            }
         }
      }
      
      override public function set changeFactor($n:Number) : void
      {
         var i:int = 0;
         var ti:TweenInfo = null;
         var filters:Array = _target.filters;
         for(i = _tweens.length - 1; i > -1; i--)
         {
            ti = _tweens[i];
            ti.target[ti.property] = ti.start + ti.change * $n;
         }
         if(!(filters[_index] is _type))
         {
            _index = filters.length - 1;
            for(i = filters.length - 1; i > -1; i--)
            {
               if(filters[i] is _type)
               {
                  _index = i;
                  break;
               }
            }
         }
         filters[_index] = _filter;
         _target.filters = filters;
      }
   }
}

