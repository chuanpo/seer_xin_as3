package com.robot.app.ogre
{
   import com.robot.app.automaticFight.AutomaticFightManager;
   import com.robot.core.CommandID;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class OgreCmdListener extends BaseBeanController
   {
      public function OgreCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.MAP_OGRE_LIST,this.onOgreList);
         finish();
      }
      
      private function onOgreList(e:SocketEvent) : void
      {
         var id:uint = 0;
         var obj:Object = null;
         if(!MapManager.isInMap)
         {
            return;
         }
         var data:ByteArray = e.data as ByteArray;
         var array:Array = [];
         for(var i:int = 0; i < 9; i++)
         {
            id = data.readUnsignedInt();
            if(id == 133)
            {
               if(!MainManager.actorModel.nono)
               {
                  return;
               }
            }
            if(Boolean(id))
            {
               OgreController.add(i,id);
               array.push({
                  "_id":id,
                  "_index":i
               });
            }
            else
            {
               OgreController.remove(i);
            }
         }
         if(array.length > 0)
         {
            obj = array[Math.floor(Math.random() * array.length)];
            AutomaticFightManager.beginFight(obj._index,obj._id);
         }
      }
   }
}

