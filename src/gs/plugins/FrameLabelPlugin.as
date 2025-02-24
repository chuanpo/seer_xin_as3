package gs.plugins
{
   import flash.display.*;
   import gs.*;
   
   public class FrameLabelPlugin extends FramePlugin
   {
      public static const VERSION:Number = 1.01;
      
      public static const API:Number = 1;
      
      public function FrameLabelPlugin()
      {
         super();
         this.propName = "frameLabel";
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         var i:int = 0;
         if(!$tween.target is MovieClip)
         {
            return false;
         }
         _target = $target as MovieClip;
         this.frame = _target.currentFrame;
         var labels:Array = _target.currentLabels;
         var label:String = $value;
         var endFrame:int = _target.currentFrame;
         for(i = labels.length - 1; i > -1; i--)
         {
            if(labels[i].name == label)
            {
               endFrame = int(labels[i].frame);
               break;
            }
         }
         if(this.frame != endFrame)
         {
            addTween(this,"frame",this.frame,endFrame,"frame");
         }
         return true;
      }
   }
}

