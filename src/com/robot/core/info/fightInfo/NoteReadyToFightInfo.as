package com.robot.core.info.fightInfo
{
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.PetSkillInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.pet.petWar.PetWarController;
   import flash.utils.IDataInput;
   import org.taomee.manager.EventManager;
   import org.taomee.ds.HashMap;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import com.robot.core.CommandID;
   // import com.adobe.serialization.json.JSON;

   public class NoteReadyToFightInfo
   {
      private var _userInfoArray:Array;
      
      private var _petArray:Array;
      
      private var _skillArray:Array;
      
      private var _obj:PetWarInfo;
      
      private var _petInfoMap:Array;
      
      private var _myCapA:Array;
      
      private var _myPetInfoA:Array;
      
      private var _petInfoArray:HashMap;

      public function NoteReadyToFightInfo(data:IDataInput)
      {
         var fUserInfo:FighetUserInfo = null;
         var petNum:uint = 0;
         var j1:int = 0;
         var info:PetInfo = null;
         var k2:uint = 0;
         var petID:uint = 0;
         var skillNum:uint = 0;
         var k1:uint = 0;
         var skillID:uint = 0;
         this._userInfoArray = [];
         this._petArray = [];
         this._skillArray = [];
         this._petInfoMap = new Array();
         this._myCapA = new Array();
         this._myPetInfoA = new Array();
         this._petInfoArray = new HashMap();
         super();
         this._obj = new PetWarInfo();
         this._obj.myPetA = new Array();
         this._obj.otherPetA = new Array();
         var petMode:uint = uint(data.readUnsignedInt());
         var shinyDecodeError:Boolean = false;
         for(var i1:int = 0; i1 < 2; i1++)
         {
            fUserInfo = new FighetUserInfo(data);
            this._userInfoArray.push(fUserInfo);
            petNum = uint(data.readUnsignedInt());
            for(j1 = 0; j1 < petNum; j1++)
            {
               info = new PetInfo(data);
               this._petInfoArray.add(info.catchTime,info);
               this._petInfoMap.push(info);
               // info.shiny = 2503;
               if(info.shiny > 1)shinyDecodeError = true;
               var skinId:int = int(info.skinID);
               if(this._petArray.indexOf(skinId) == -1 && skinId!= 0)
               {
                  this._petArray.push(skinId);
               }
               if(this._petArray.indexOf(info.id) == -1)
               {
                  this._petArray.push(info.id);
               }
               if(fUserInfo.id == MainManager.actorID)
               {
                  this._obj.myPetA.push(info.id);
                  trace("分配给我的精灵ID====" + info.id + "捕获时间:" + info.catchTime);
                  this._myCapA.push(info.catchTime);
                  this._myPetInfoA.push(info);
               }
               else
               {
                  this._obj.otherPetA.push(info.id);
                  trace("分配给别人的精灵ID====" + info.id + "捕获时间:" + info.catchTime);
               }
               for(k2 = 0; k2 < info.skillArray.length; k2++)
               {
                  if(this._skillArray.indexOf((info.skillArray[k2] as PetSkillInfo).id) == -1)
                  {
                     this._skillArray.push((info.skillArray[k2] as PetSkillInfo).id);
                  }
               }
               // if(petMode == 14)
               // {
               //    info = new PetInfo(data);
               //    this._petInfoMap.push(info);
               //    if(this._petArray.indexOf(info.id) == -1)
               //    {
               //       this._petArray.push(info.id);
               //    }
               //    if(fUserInfo.id == MainManager.actorID)
               //    {
               //       this._obj.myPetA.push(info.id);
               //       trace("分配给我的精灵ID====" + info.id + "捕获时间:" + info.catchTime);
               //       this._myCapA.push(info.catchTime);
               //       this._myPetInfoA.push(info);
               //    }
               //    else
               //    {
               //       this._obj.otherPetA.push(info.id);
               //       trace("分配给别人的精灵ID====" + info.id + "捕获时间:" + info.catchTime);
               //    }
               //    for(k2 = 0; k2 < info.skillArray.length; k2++)
               //    {
               //       if(this._skillArray.indexOf((info.skillArray[k2] as PetSkillInfo).id) == -1)
               //       {
               //          this._skillArray.push((info.skillArray[k2] as PetSkillInfo).id);
               //       }
               //    }
               // }
               // else
               // {
               //    petID = uint(data.readUnsignedInt());
               //    if(this._petArray.indexOf(petID) == -1)
               //    {
               //       this._petArray.push(petID);
               //    }
               //    if(fUserInfo.id == MainManager.actorID)
               //    {
               //       this._obj.myPetA.push(petID);
               //    }
               //    else
               //    {
               //       this._obj.otherPetA.push(petID);
               //    }
               //    skillNum = uint(data.readUnsignedInt());
               //    for(k1 = 0; k1 < skillNum; k1++)
               //    {
               //       skillID = uint(data.readUnsignedInt());
               //       if(this._skillArray.indexOf(skillID) == -1)
               //       {
               //          this._skillArray.push(skillID);
               //       }
            }
         }
         if(shinyDecodeError)
         {
            var fightInfoStr:String ="NoteReadyToFightInfo:" ;
            for each(var userInfo:FighetUserInfo in _userInfoArray)
            {
               fightInfoStr += JSON.stringify(userInfo) + ",";
            }
            for each(var petInfo:PetInfo in _petInfoArray.getValues())
            {
               fightInfoStr += JSON.stringify(petInfo) + ",";
               if(petInfo.shiny > 1) petInfo.shiny = 0;
            }
            // Alarm.show(fightInfoStr);
            var byte:ByteArray = new ByteArray();
            var sLen:int = fightInfoStr.length;
            var i:int = 0;
            for(i = 0; i < sLen; i++)
            {
               byte.writeUTFBytes(fightInfoStr.charAt(i));
            }
            byte.writeUTFBytes("0");
            SocketConnection.send(CommandID.XIN_CHECK,0);
            SocketConnection.send(CommandID.XIN_CHECK,1,byte.length,byte);
         }
         PetWarController.myPetInfoA = this._myPetInfoA;
         PetWarController.allPetA = this._petInfoMap;
         PetWarController.myCapA = this._myCapA;
         EventManager.dispatchEvent(new PetFightEvent(PetFightEvent.GET_FIGHT_INFO_SUCCESS,this._obj));
      }
      
      public function get petArray() : Array
      {
         return this._petArray;
      }
      
      public function get skillArray() : Array
      {
         return this._skillArray;
      }
      
      public function get userInfoArray() : Array
      {
         return this._userInfoArray;
      }

      public function get petInfoArray() : HashMap
      {
         return this._petInfoArray;
      }
   }
}

