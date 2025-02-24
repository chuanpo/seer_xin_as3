package com.robot.core.manager
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.config.xml.SkillXMLInfo;
   import com.robot.core.event.PetEvent;
   import com.robot.core.info.pet.ExeingPetInfo;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.PetListInfo;
   import com.robot.core.info.pet.PetSkillInfo;
   import com.robot.core.info.pet.PetTakeOutInfo;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   
   [Event(name="storageList",type="com.robot.core.event.PetEvent")]
   [Event(name="storageRemoved",type="com.robot.core.event.PetEvent")]
   [Event(name="storageAdded",type="com.robot.core.event.PetEvent")]
   [Event(name="storageUpdateInfo",type="com.robot.core.event.PetEvent")]
   [Event(name="updateInfo",type="com.robot.core.event.PetEvent")]
   [Event(name="cureOneComplete",type="com.robot.core.event.PetEvent")]
   [Event(name="cureComplete",type="com.robot.core.event.PetEvent")]
   [Event(name="setDefault",type="com.robot.core.event.PetEvent")]
   [Event(name="removed",type="com.robot.core.event.PetEvent")]
   [Event(name="added",type="com.robot.core.event.PetEvent")]
   public class PetManager
   {
      public static var defaultTime:uint;
      
      public static var currentShowCatchTime:uint;
      
      public static var handleCatchTime:uint;
      
      private static var _isgetdata:Boolean;
      
      private static var _curEndPetInfo:PetInfo;
      
      private static var curRoweiPetInfo:PetListInfo;
      
      private static var curRetrievePetInfo:PetListInfo;
      
      private static var _instance:EventDispatcher;
      
      private static var _bagMap:HashMap = new HashMap();
      
      public static var novicePet:uint = 0;
      
      public static var npcPet:uint = 0;
      
      public static var showInfo:PetInfo = null;
      
      private static var b:Boolean = true;
      
      private static var _storageMap:HashMap = new HashMap();
      
      private static var _exePetListMap:HashMap = new HashMap();
      
      private static var roweiPetMap:HashMap = new HashMap();
      
      public function PetManager()
      {
         super();
      }
      
      public static function checkHandlePet(catchTime:uint) : void
      {
         if(handleCatchTime > 0)
         {
            _bagMap.remove(handleCatchTime);
            _bagMap.add(catchTime,null);
            upDate();
            handleCatchTime = 0;
         }
      }
      
      public static function initData(data:IDataInput, len:uint) : void
      {
         var info:PetInfo = null;
         for(var i:int = 0; i < len; i++)
         {
            info = new PetInfo(data);
            if(i == 0)
            {
               info.isDefault = true;
               defaultTime = info.catchTime;
            }
            _bagMap.add(info.catchTime,info);
         }
      }
      
      public static function upDate() : void
      {
         var ts:Array = null;
         var upLoop:Function = function(i:int):void
         {
            var catchTime:uint;
            if(i == length)
            {
               dispatchEvent(new PetEvent(PetEvent.UPDATE_INFO,0));
               ts = null;
               b = true;
               return;
            }
            catchTime = uint(ts[i]);
            SocketConnection.addCmdListener(CommandID.GET_PET_INFO,function(e:SocketEvent):void
            {
               SocketConnection.removeCmdListener(CommandID.GET_PET_INFO,arguments.callee);
               var info:PetInfo = e.data as PetInfo;
               if(info.catchTime == defaultTime)
               {
                  info.isDefault = true;
               }
               if(containsBagForCapTime(info.catchTime))
               {
                  _bagMap.add(info.catchTime,info);
               }
               ++i;
               upLoop(i);
            });
            SocketConnection.send(CommandID.GET_PET_INFO,catchTime);
         };
         if(!b)
         {
            return;
         }
         b = false;
         trace("更新宠物信息");
         ts = catchTimes;
         upLoop(0);
      }
      
      public static function add(info:PetInfo) : void
      {
         if(_bagMap.length >= 6)
         {
            addStorage(info.id,info.catchTime);
            return;
         }
         if(_bagMap.length == 0)
         {
            info.isDefault = true;
            defaultTime = info.catchTime;
         }
         _bagMap.add(info.catchTime,info);
         dispatchEvent(new PetEvent(PetEvent.ADDED,info.catchTime));
      }
      
      public static function remove(catchTime:uint) : PetInfo
      {
         var i:PetInfo = _bagMap.remove(catchTime);
         if(Boolean(i))
         {
            if(Boolean(showInfo))
            {
               if(showInfo.catchTime == catchTime)
               {
                  showInfo = null;
               }
            }
            dispatchEvent(new PetEvent(PetEvent.REMOVED,catchTime));
            return i;
         }
         return null;
      }
      
      public static function deletePet(catchTime:uint) : void
      {
         _bagMap.remove(catchTime);
         _storageMap.remove(catchTime);
      }
      
      public static function containsBagForID(id:uint) : Boolean
      {
         var arr:Array = _bagMap.getValues();
         return arr.some(function(item:PetInfo, index:int, array:Array):Boolean
         {
            if(id == item.id)
            {
               return true;
            }
            return false;
         });
      }
      
      public static function containsBagForCapTime(cap:uint) : Boolean
      {
         var arr:Array = _bagMap.getValues();
         return arr.some(function(item:PetInfo, index:int, array:Array):Boolean
         {
            if(cap == item.catchTime)
            {
               return true;
            }
            return false;
         });
      }
      
      public static function getPetInfo(catchTime:uint) : PetInfo
      {
         return _bagMap.getValue(catchTime);
      }
      
      public static function get length() : uint
      {
         return _bagMap.length;
      }
      
      public static function get catchTimes() : Array
      {
         return _bagMap.getKeys();
      }
      
      public static function get infos() : Array
      {
         return _bagMap.getValues();
      }
      
      public static function setIn(catchTime:uint, flag:uint, id:uint = 0) : void
      {
         SocketConnection.addCmdListener(CommandID.PET_RELEASE,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.PET_RELEASE,arguments.callee);
            var info:PetTakeOutInfo = e.data as PetTakeOutInfo;
            if(info.flag == 1)
            {
               add(info.petInfo);
            }
            else
            {
               addStorage(id,catchTime);
            }
            _setDefault(info.firstPetTime);
         });
         SocketConnection.send(CommandID.PET_RELEASE,catchTime,flag);
      }
      
      public static function bagToInStorage(catchTime:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.PET_RELEASE,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.PET_RELEASE,arguments.callee);
            var info:PetTakeOutInfo = e.data as PetTakeOutInfo;
            var i:PetInfo = remove(catchTime);
            if(Boolean(i))
            {
               addStorage(i.id,i.catchTime);
            }
            _setDefault(info.firstPetTime);
         });
         SocketConnection.send(CommandID.PET_RELEASE,catchTime,0);
      }
      
      public static function storageToInBag(catchTime:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.PET_RELEASE,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.PET_RELEASE,arguments.callee);
            var info:PetTakeOutInfo = e.data as PetTakeOutInfo;
            removeStorage(catchTime);
            add(info.petInfo);
            _setDefault(info.firstPetTime);
         });
         SocketConnection.send(CommandID.PET_RELEASE,catchTime,1);
      }
      
      public static function setDefault(catchTime:uint, isNet:Boolean = true) : void
      {
         if(defaultTime == catchTime)
         {
            return;
         }
         if(isNet)
         {
            SocketConnection.addCmdListener(CommandID.PET_DEFAULT,function(e:SocketEvent):void
            {
               SocketConnection.removeCmdListener(CommandID.PET_DEFAULT,arguments.callee);
               _setDefault(catchTime);
            });
            SocketConnection.send(CommandID.PET_DEFAULT,catchTime);
         }
         else
         {
            _setDefault(catchTime);
         }
      }
      
      private static function _setDefault(catchTime:uint) : void
      {
         var info:PetInfo = _bagMap.getValue(defaultTime) as PetInfo;
         if(Boolean(info))
         {
            info.isDefault = false;
         }
         info = _bagMap.getValue(catchTime) as PetInfo;
         if(Boolean(info))
         {
            defaultTime = catchTime;
            info.isDefault = true;
            dispatchEvent(new PetEvent(PetEvent.SET_DEFAULT,defaultTime));
         }
      }
      
      public static function showCurrent() : void
      {
         showPet(currentShowCatchTime);
      }
      
      public static function showPet(catchTime:uint) : void
      {
         if(catchTime == 0)
         {
            catchTime = uint(catchTimes[0]);
         }
         currentShowCatchTime = catchTime;
         var info:PetInfo = _bagMap.getValue(catchTime);
         if(!info)
         {
            Alarm.show("你还没有精灵");
            return;
         }
         if(showInfo == null)
         {
            showInfo = info;
            SocketConnection.send(CommandID.PET_SHOW,info.catchTime,1);
         }
         else if(showInfo.catchTime == catchTime)
         {
            showInfo = null;
            SocketConnection.send(CommandID.PET_SHOW,info.catchTime,0);
         }
         else
         {
            SocketConnection.send(CommandID.PET_SHOW,showInfo.catchTime,0);
            showInfo = info;
            SocketConnection.send(CommandID.PET_SHOW,info.catchTime,1);
         }
      }
      
      public static function cureAll(isTip:Boolean = true) : void
      {
         var isCure:Boolean = false;
         _bagMap.eachValue(function(o:PetInfo):void
         {
            var info:PetSkillInfo = null;
            if(o.hp != o.maxHp)
            {
               isCure = true;
               return;
            }
            for(var i:int = 0; i < o.skillNum; i++)
            {
               info = o.skillArray[i] as PetSkillInfo;
               if(info.pp != SkillXMLInfo.getPP(info.id))
               {
                  isCure = true;
                  return;
               }
            }
         });
         if(!isCure)
         {
            Alarm.show("你的精灵们不需要恢复体力");
            return;
         }
         SocketConnection.addCmdListener(CommandID.PET_CURE,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.PET_CURE,arguments.callee);
            _bagMap.eachValue(function(o:PetInfo):void
            {
               var info:PetSkillInfo = null;
               o.hp = o.maxHp;
               for(var i:int = 0; i < o.skillNum; i++)
               {
                  info = o.skillArray[i] as PetSkillInfo;
                  info.pp = SkillXMLInfo.getPP(info.id);
               }
            });
            dispatchEvent(new PetEvent(PetEvent.CURE_COMPLETE,0));
            if(isTip)
            {
               Alarm.show("你的精灵已经重新充满活力了");
            }
            if(MainManager.actorInfo.superNono != 1)
            {
               MainManager.actorInfo.coins -= 50;
            }
         });
         SocketConnection.send(CommandID.PET_CURE);
      }
      
      public static function cure(catchTime:uint) : void
      {
         var i:int;
         var info:PetSkillInfo = null;
         var isCure:Boolean = false;
         var petInfo:PetInfo = _bagMap.getValue(catchTime);
         if(!petInfo)
         {
            Alarm.show("没有找到精灵");
            return;
         }
         if(petInfo.hp != petInfo.maxHp)
         {
            isCure = true;
         }
         for(i = 0; i < petInfo.skillNum; i++)
         {
            info = petInfo.skillArray[i] as PetSkillInfo;
            if(info.pp != SkillXMLInfo.getPP(info.id))
            {
               isCure = true;
               break;
            }
         }
         if(!isCure)
         {
            Alarm.show("你的精灵不需要恢复体力");
            return;
         }
         SocketConnection.addCmdListener(CommandID.PET_ONE_CURE,function(e:SocketEvent):void
         {
            var i:int = 0;
            var info:PetSkillInfo = null;
            SocketConnection.removeCmdListener(CommandID.PET_ONE_CURE,arguments.callee);
            var by:ByteArray = e.data as ByteArray;
            var ct:uint = by.readUnsignedInt();
            var petInfo:PetInfo = _bagMap.getValue(ct);
            if(Boolean(petInfo))
            {
               petInfo.hp = petInfo.maxHp;
               for(i = 0; i < petInfo.skillNum; i++)
               {
                  info = petInfo.skillArray[i] as PetSkillInfo;
                  info.pp = SkillXMLInfo.getPP(info.id);
               }
            }
            dispatchEvent(new PetEvent(PetEvent.CURE_ONE_COMPLETE,ct));
            Alarm.show("你的精灵已经重新充满活力了");
            if(MainManager.actorInfo.superNono != 1)
            {
               MainManager.actorInfo.coins -= 20;
            }
         });
         SocketConnection.send(CommandID.PET_ONE_CURE,catchTime);
      }
      
      public static function get storageLength() : int
      {
         return _storageMap.length - _bagMap.length;
      }
      
      public static function get allLength() : int
      {
         return _storageMap.length;
      }
      
      public static function getAll() : Array
      {
         var i1:int = 0;
         var petInfo:PetListInfo = null;
         var a:Array = _storageMap.getValues();
         if(_bagMap.length > 0)
         {
            for(i1 = 0; i1 < _bagMap.length; i1++)
            {
               if(containsStorageForCapTime((_bagMap.getValues()[i1] as PetInfo).catchTime) == false)
               {
                  petInfo = new PetListInfo();
                  petInfo.catchTime = (_bagMap.getValues()[i1] as PetInfo).catchTime;
                  petInfo.id = (_bagMap.getValues()[i1] as PetInfo).id;
                  a.push(petInfo);
               }
            }
         }
         return a;
      }
      
      public static function getCanExePetList() : Array
      {
         var i2:int = 0;
         var i1:int = 0;
         var petInfo:PetListInfo = null;
         var a:Array = _storageMap.getValues();
         if(Boolean(a))
         {
            for(i2 = 0; i2 < a.length; i2++)
            {
               if((a[i2] as PetListInfo).course != 0)
               {
                  a.splice(i2,1);
                  i2--;
               }
            }
         }
         if(_bagMap.length > 0)
         {
            for(i1 = 0; i1 < _bagMap.length; i1++)
            {
               if(containsStorageForCapTime((_bagMap.getValues()[i1] as PetInfo).catchTime) == false)
               {
                  petInfo = new PetListInfo();
                  petInfo.catchTime = (_bagMap.getValues()[i1] as PetInfo).catchTime;
                  petInfo.id = (_bagMap.getValues()[i1] as PetInfo).id;
                  a.push(petInfo);
               }
            }
         }
         return a;
      }
      
      public static function getStorage() : Array
      {
         var arr:Array = _storageMap.getValues();
         return arr.filter(function(item:PetListInfo, index:int, array:Array):Boolean
         {
            if(!_bagMap.containsKey(item.catchTime))
            {
               return true;
            }
            return false;
         });
      }
      
      public static function getStorageList() : void
      {
         if(_isgetdata)
         {
            dispatchEvent(new PetEvent(PetEvent.STORAGE_LIST,0));
            return;
         }
         SocketConnection.addCmdListener(CommandID.GET_PET_LIST,function(e:SocketEvent):void
         {
            var info:PetListInfo = null;
            SocketConnection.removeCmdListener(CommandID.GET_PET_LIST,arguments.callee);
            var by:ByteArray = e.data as ByteArray;
            var len:uint = by.readUnsignedInt();
            for(var i:int = 0; i < len; i++)
            {
               info = new PetListInfo(by);
               _storageMap.add(info.catchTime,info);
            }
            if(MainManager.actorInfo.hasNono)
            {
               if(Boolean(NonoManager.info))
               {
                  if(Boolean(NonoManager.info.func[3]))
                  {
                     getExePetList();
                  }
                  else
                  {
                     _isgetdata = true;
                     dispatchEvent(new PetEvent(PetEvent.STORAGE_LIST,0));
                  }
               }
               else
               {
                  _isgetdata = true;
                  dispatchEvent(new PetEvent(PetEvent.STORAGE_LIST,0));
               }
            }
            else
            {
               _isgetdata = true;
               dispatchEvent(new PetEvent(PetEvent.STORAGE_LIST,0));
            }
         });
         SocketConnection.send(CommandID.GET_PET_LIST);
      }
      
      private static function getExePetList() : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_EXE_LIST,onGetListSucHandler);
         SocketConnection.send(CommandID.NONO_EXE_LIST);
      }
      
      private static function onGetListSucHandler(e:SocketEvent) : void
      {
         var i1:int = 0;
         var exePet:ExeingPetInfo = null;
         var listInfo:PetListInfo = null;
         SocketConnection.removeCmdListener(CommandID.NONO_EXE_LIST,onGetListSucHandler);
         var by:ByteArray = e.data as ByteArray;
         var count:uint = by.readUnsignedInt();
         if(count > 0)
         {
            for(i1 = 0; i1 < count; i1++)
            {
               exePet = new ExeingPetInfo(by);
               _exePetListMap.add(exePet._capTm,exePet);
               listInfo = new PetListInfo();
               listInfo.id = exePet._petId;
               listInfo.catchTime = exePet._capTm;
               listInfo.course = exePet._course;
               _storageMap.add(exePet._capTm,listInfo);
               if(containsBagForCapTime(exePet._capTm))
               {
                  _bagMap.remove(exePet._capTm);
               }
            }
         }
         _isgetdata = true;
         dispatchEvent(new PetEvent(PetEvent.STORAGE_LIST,0));
      }
      
      public static function get exePetListMap() : HashMap
      {
         return _exePetListMap;
      }
      
      public static function getBagMap() : Array
      {
         var a:Array = null;
         var i1:int = 0;
         var info:PetListInfo = null;
         if(Boolean(_bagMap))
         {
            if(_bagMap.getValues().length <= 0)
            {
               return [];
            }
            a = new Array();
            for(i1 = 0; i1 < _bagMap.getValues().length; i1++)
            {
               info = new PetListInfo();
               info.catchTime = (_bagMap.getValues()[i1] as PetInfo).catchTime;
               info.id = (_bagMap.getValues()[i1] as PetInfo).id;
               a.push(info);
            }
            return a;
         }
         return [];
      }
      
      public static function startExePet(capTime:uint, type:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_START_EXE,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.NONO_START_EXE,arguments.callee);
            var by:ByteArray = e.data as ByteArray;
            var capTime:Number = by.readUnsignedInt();
            var petId:Number = by.readUnsignedInt();
            var endTime:Number = by.readUnsignedInt();
            var course:Number = by.readUnsignedInt();
            var exeInfo:ExeingPetInfo = new ExeingPetInfo();
            exeInfo._flag = 0;
            exeInfo._capTm = capTime;
            exeInfo._petId = petId;
            exeInfo._remainDay = course * 24;
            exeInfo._course = course;
            _exePetListMap.add(exeInfo._capTm,exeInfo);
            var listInfo:PetListInfo = new PetListInfo();
            listInfo.id = exeInfo._petId;
            listInfo.catchTime = exeInfo._capTm;
            listInfo.course = exeInfo._course;
            _storageMap.add(exeInfo._capTm,listInfo);
            if(containsBagForCapTime(exeInfo._capTm))
            {
               _bagMap.remove(exeInfo._capTm);
            }
            dispatchEvent(new PetEvent(PetEvent.START_EXE_PET,0));
         });
         SocketConnection.send(CommandID.NONO_START_EXE,capTime,type);
      }
      
      public static function stopExePet(id:uint, cap:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_END_EXE,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.NONO_END_EXE,arguments.callee);
            var by:ByteArray = e.data as ByteArray;
            var exp:uint = by.readUnsignedInt();
            if(exp == 0)
            {
               Alarm.show("训练完成，你的精灵已经回到仓库中！");
            }
            else
            {
               Alarm.show("训练完成，你的精灵获得了 " + TextFormatUtil.getRedTxt(exp.toString()) + " 经验！");
            }
            _exePetListMap.remove(cap);
            var info:PetListInfo = new PetListInfo();
            info.id = id;
            info.catchTime = cap;
            info.course = 0;
            _storageMap.add(info.catchTime,info);
            if(containsBagForCapTime(info.catchTime))
            {
               _bagMap.remove(info.catchTime);
            }
            dispatchEvent(new PetEvent(PetEvent.STOP_EXE_PET,0));
         });
         SocketConnection.send(CommandID.NONO_END_EXE,cap);
      }
      
      public static function set curEndPetInfo(info:PetInfo) : void
      {
         _curEndPetInfo = info;
      }
      
      public static function get curEndPetInfo() : PetInfo
      {
         return _curEndPetInfo;
      }
      
      public static function getRoweiPetList() : void
      {
         roweiPetMap.clear();
         SocketConnection.addCmdListener(CommandID.PET_ROWEI_LIST,onRoweiListHandler);
         SocketConnection.send(CommandID.PET_ROWEI_LIST);
      }
      
      private static function onRoweiListHandler(e:SocketEvent) : void
      {
         var info:PetListInfo = null;
         SocketConnection.removeCmdListener(CommandID.PET_ROWEI_LIST,onRoweiListHandler);
         var roweiInfo:ByteArray = e.data as ByteArray;
         var count:uint = roweiInfo.readUnsignedInt();
         for(var i:int = 0; i < count; i++)
         {
            info = new PetListInfo(roweiInfo);
            roweiPetMap.add(info.catchTime,info);
         }
         dispatchEvent(new PetEvent(PetEvent.GET_ROWEI_PET_LIST,0));
      }
      
      public static function get roweiPetLength() : uint
      {
         return roweiPetMap.length;
      }
      
      public static function getRoweiTypeList(t:uint) : Array
      {
         var arr:Array = roweiPetMap.getValues();
         return arr.filter(function(item:PetListInfo, index:int, array:Array):Boolean
         {
            if(PetXMLInfo.getType(item.id) == t.toString())
            {
               return true;
            }
            return false;
         });
      }
      
      public static function roweiPet(id:uint, catchTime:uint) : void
      {
         curRoweiPetInfo = new PetListInfo();
         curRoweiPetInfo.id = id;
         curRoweiPetInfo.catchTime = catchTime;
         SocketConnection.addCmdListener(CommandID.PET_ROWEI,onRoweiPetSuccessHandler);
         SocketConnection.send(CommandID.PET_ROWEI,id,catchTime);
      }
      
      public static function onRoweiPetSuccessHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.PET_ROWEI,onRoweiPetSuccessHandler);
         _storageMap.remove(curRoweiPetInfo.catchTime);
         roweiPetMap.add(curRoweiPetInfo.catchTime,curRoweiPetInfo);
         dispatchEvent(new PetEvent(PetEvent.ROWEI_PET,curRoweiPetInfo.catchTime));
      }
      
      public static function retrievePet(id:uint, catchTime:uint) : void
      {
         curRetrievePetInfo = new PetListInfo();
         curRetrievePetInfo.id = id;
         curRetrievePetInfo.catchTime = catchTime;
         SocketConnection.addCmdListener(CommandID.PET_RETRIEVE,onRetrievePetSuccessHandler);
         SocketConnection.send(CommandID.PET_RETRIEVE,catchTime);
      }
      
      private static function onRetrievePetSuccessHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.PET_RETRIEVE,onRetrievePetSuccessHandler);
         _storageMap.add(curRetrievePetInfo.catchTime,curRetrievePetInfo);
         roweiPetMap.remove(curRetrievePetInfo.catchTime);
         dispatchEvent(new PetEvent(PetEvent.RETRIEVE_PET,curRetrievePetInfo.catchTime));
      }
      
      public static function storageUpDate(catchTime:uint, event:Function) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_PET_INFO,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.GET_PET_INFO,arguments.callee);
            event(e.data as PetInfo);
         });
         SocketConnection.send(CommandID.GET_PET_INFO,catchTime);
      }
      
      public static function getStorageTypeList(t:uint) : Array
      {
         var arr:Array = getStorage();
         return arr.filter(function(item:PetListInfo, index:int, array:Array):Boolean
         {
            if(PetXMLInfo.getType(item.id) == t.toString())
            {
               return true;
            }
            return false;
         });
      }
      
      public static function addStorage(id:uint, catchTime:uint) : void
      {
         var info:PetListInfo = new PetListInfo();
         info.id = id;
         info.catchTime = catchTime;
         _storageMap.add(catchTime,info);
         dispatchEvent(new PetEvent(PetEvent.STORAGE_ADDED,catchTime));
      }
      
      public static function removeStorage(catchTime:uint) : PetListInfo
      {
         var i:PetListInfo = _storageMap.remove(catchTime);
         if(Boolean(i))
         {
            dispatchEvent(new PetEvent(PetEvent.STORAGE_REMOVED,catchTime));
            return i;
         }
         return null;
      }
      
      public static function containsStorageForID(id:uint) : Boolean
      {
         var arr:Array = _storageMap.getValues();
         return arr.some(function(item:PetListInfo, index:int, array:Array):Boolean
         {
            if(id == item.id)
            {
               return true;
            }
            return false;
         });
      }
      
      public static function containsStorageForCapTime(cap:uint) : Boolean
      {
         var arr:Array = _storageMap.getValues();
         return arr.some(function(item:PetListInfo, index:int, array:Array):Boolean
         {
            if(cap == item.catchTime)
            {
               return true;
            }
            return false;
         });
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(_instance == null)
         {
            _instance = new EventDispatcher();
         }
         return _instance;
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         getInstance().addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         getInstance().removeEventListener(type,listener,useCapture);
      }
      
      public static function dispatchEvent(event:Event) : void
      {
         if(hasEventListener(event.type))
         {
            getInstance().dispatchEvent(event);
         }
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return getInstance().hasEventListener(type);
      }
      
      public static function willTrigger(type:String) : Boolean
      {
         return getInstance().willTrigger(type);
      }
   }
}

