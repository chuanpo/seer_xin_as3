package com.robot.core.aticon
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.SpecialXMLInfo;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.skeleton.EmptySkeletonStrategy;
   import com.robot.core.utils.Direction;
   import flash.display.MovieClip;
   import gs.TweenLite;
   import gs.easing.Bounce;
   
   public class PeculiarAction
   {
      public function PeculiarAction()
      {
         super();
      }
      
      public function execute(obj:BasePeoleModel, dir:String, isNet:Boolean = true) : void
      {
         var id:uint = 0;
         var bodyMCArray:Array = null;
         var compose:MovieClip = null;
         var skeleton:EmptySkeletonStrategy = null;
         var num:uint = 0;
         var i:uint = 0;
         var mc:MovieClip = null;
         if(isNet)
         {
            SocketConnection.send(CommandID.DANCE_ACTION,10001,Direction.strToIndex(obj.direction));
         }
         else
         {
            id = SpecialXMLInfo.getSpecialID(obj.info.clothIDs);
            if(id > 0)
            {
               obj.stop();
               obj.specialAction(id);
               return;
            }
            bodyMCArray = [];
            obj.sprite.addEventListener(RobotEvent.WALK_START,function(e:RobotEvent):void
            {
               var j:MovieClip = null;
               obj.sprite.removeEventListener(RobotEvent.WALK_START,arguments.callee);
               for each(j in bodyMCArray)
               {
                  TweenLite.to(j,0.2,{
                     "alpha":1,
                     "scaleX":1,
                     "scaleY":1
                  });
               }
               TweenLite.to(compose,0.5,{
                  "y":-21.4,
                  "ease":Bounce.easeOut
               });
            });
            obj.stop();
            obj.direction = dir;
            skeleton = obj.skeleton as EmptySkeletonStrategy;
            compose = skeleton.getBodyMC();
            num = uint(compose.numChildren);
            for(i = 0; i < num; i++)
            {
               mc = compose.getChildAt(i) as MovieClip;
               if(mc.name != "cloth" && mc.name != "color" && mc.name != "waist" && mc.name != "head" && mc.name != "decorator")
               {
                  bodyMCArray.push(mc);
                  TweenLite.to(mc,0.2,{
                     "alpha":0,
                     "scaleX":0,
                     "scaleY":0
                  });
               }
            }
            TweenLite.to(compose,0.5,{
               "y":-8,
               "ease":Bounce.easeOut
            });
         }
      }
      
      public function keepDown(ske:EmptySkeletonStrategy) : void
      {
         var mc:MovieClip = null;
         if(!ske)
         {
            return;
         }
         var compose:MovieClip = ske.getBodyMC();
         var num:uint = uint(compose.numChildren);
         for(var i:uint = 0; i < num; i++)
         {
            mc = compose.getChildAt(i) as MovieClip;
            if(mc.name != "cloth" && mc.name != "color" && mc.name != "waist" && mc.name != "head" && mc.name != "decorator")
            {
               TweenLite.to(mc,0.2,{
                  "alpha":0,
                  "scaleX":0,
                  "scaleY":0
               });
            }
         }
         TweenLite.to(compose,0.5,{
            "y":-8,
            "ease":Bounce.easeOut
         });
      }
      
      public function standUp(ske:EmptySkeletonStrategy) : void
      {
         var mc:MovieClip = null;
         var compose:MovieClip = ske.getBodyMC();
         var num:uint = uint(compose.numChildren);
         for(var i:uint = 0; i < num; i++)
         {
            mc = compose.getChildAt(i) as MovieClip;
            if(mc.name != "cloth" && mc.name != "color" && mc.name != "waist" && mc.name != "head" && mc.name != "decorator")
            {
               TweenLite.to(mc,0.2,{
                  "alpha":1,
                  "scaleX":1,
                  "scaleY":1
               });
            }
         }
         TweenLite.to(compose,0.5,{
            "y":-21.4,
            "ease":Bounce.easeOut
         });
      }
   }
}

