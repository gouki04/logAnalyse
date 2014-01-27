-- lua file system
local lfs = require('lfs')

local year, mon, day = 2013, 12, 15
local t_time = {year=year, month=mon, day=day, hour=0, min=0, sec=0}

local rootpath = 'D:\\zxy\\zxy_log\\logs'
local date_folder_name = os.date('%Y-%m-%d', os.time(t_time))

local libsystem_kernel_dylib_crash_func_tablelocal = {
	[71208] = "__semwait_signal + 24",
	[5044] = "kevent + 24",
	[76736] = "0x3a443000 + 76736",
	[69736] = "__psynch_cvwait + 24",
	[3844] = "0x39667000 + 3844",
	[5704] = "0x3a443000 + 5704",
	[5584] = "0x3c8b8000 + 5584",
	[4100] = "mach_msg_trap + 20",
	[4112] = "mach_msg_trap + 20",
	[72916] = "__workq_kernreturn + 8",
	[71060] = "0x3a443000 + 71060",
	[70444] = "__pthread_kill + 8",
	[73112] = "0x3c8b8000 + 73112",
	[70860] = "0x3adf6000 + 70860",
	[70480] = "__pthread_kill + 8",
	[69772] = "0x39582000 + 69772",
	[76636] = "sem_wait + 12",
	[3632] = "0x3c8b8000 + 3632",
	[5032] = "kevent + 24",
	[3764] = "0x3a443000 + 3764",
	[71024] = "__select + 20",
}

local crash_func_table = {
	[1806311] = "luaD_pcall (ldo.c:464)",
	[867899] = "cocos2d::unzLocateFile(void*, char const*, int) (unzip.cpp:1135)",
	[2639645] = "HttpOp::startThread(void*) (HttpOp.cpp:93)",
	[37525] = "__tcf_1 (AppController.mm:54)",
	[1229398] = "dbUIScrollArea::touchUp(cocos2d::CCPoint const&) (dbUIScrollArea.cpp:309)",
	[1284077] = "dbUISimpleSkin::~dbUISimpleSkin() (dbUISkin.h:150)",
	[1429715] = "non-virtual thunk to dbLuaEngine::executeUIEvent(int const&, dbUIWidget*, dbUIEvent*) (dbLuaEngine.cpp:310)",
	[70675] = "AppDelegate::~AppDelegate() (Singleton.h:51)",
	[1785887] = "lua_pcall (lapi.c:822)",
	[862031] = "cocos2d::unz64local_getShort(cocos2d::zlib_filefunc64_32_def_s const*, void*, unsigned long*) (unzip.cpp:252)",
	[1103707] = "destroyUISys() (Singleton.h:51)",
	[2640707] = "NetSocket::init(std::string const&, int) (NetSocket.cpp:65)",
	[231159] = "NetTcpSys::connect(std::string const&, int) (dbNetTcpSys.cpp:29)",
	[1143059] = "dbUIEventScriptHandler::execute(dbUIWidget*, dbUIEvent*) (dbUIEventHandler.cpp:69)",
	[1036031] = "DES_DecryptBlock (DES.cpp:333)",
	[1214603] = "dbUIWidget::clicked(cocos2d::CCPoint const&) (dbUIWidget.cpp:98)",
	[1928472] = "tolua_DBUI_dbUITabControl_getContent00(lua_State*) (LuaDBUI.cpp:9808)",
	[796887] = "cocos2d::CCTimer::update(float) (CCScheduler.cpp:163)",
	[228797] = "dbNetSys::updateNet(float) (dbNetSys.cpp:276)",
	[1438939] = "dbLuaStack::executeFunctionByHandler(int, int) (dbLuaStack.cpp:588)",
	[69431] = "main (main.m:14)",
	[1120081] = "dbUISkinMgr::~dbUISkinMgr() (dbUISkinMgr.cpp:108)",
	[1187023] = "non-virtual thunk to dbUILayer::ccTouchMoved(cocos2d::CCTouch*, cocos2d::CCEvent*) + 11",
	[1804823] = "luaD_rawrunprotected (ldo.c:119)",
	[2649990] = "TcpSocket::Connect(char const*, unsigned short, unsigned int) (_structs.h:193)",
	[1012537] = "dbResTextureLoader::loadResThreadSafe(std::string const&) (dbResTextureLoader.cpp:155)",
	[1785925] = "f_call (lapi.c:801)",
	[2649973] = "TcpSocket::Connect(char const*, unsigned short, unsigned int) (TcpSocket.cpp:234)",
	[90479] = "dbCoolDownSys::update(float) (dbCoolDownSys.cpp:337)",
	[1845719] = "luaV_gettable (lvm.c:125)",
	[786681] = "cocos2d::CCDisplayLinkDirector::mainLoop() (CCDirector.cpp:966)",
	[798179] = "cocos2d::CCTimer::update(float) (CCScheduler.cpp:163)",
	[1234057] = "dbUIScrollArea::clicked(cocos2d::CCPoint const&) (dbUIScrollArea.cpp:261)",
	[1841126] = "luaH_getnum (ltable.c:437)",
	[1854413] = "class_index_event (tolua_event.c:179)",
	[1805869] = "luaD_call (ldo.c:377)",
	[801249] = "cocos2d::CCScheduler::update(float) (CCScheduler.cpp:807)",
	[2645919] = "DataStick::_unpack(bool, std::tr1::shared_ptr<IOBufferHelper>, unsigned int, unsigned int&, bool&, unsigned int&) (DataStick.cpp:162)",
	[925679] = "cocos2d::CCTouchDispatcher::touches(cocos2d::CCSet*, cocos2d::CCEvent*, unsigned int) (CCTouchDispatcher.cpp:374)",
	[1430291] = "non-virtual thunk to dbLuaEngine::executeUIEvent(int const&, dbUIWidget*, dbUIEvent*) (dbLuaEngine.cpp:310)",
	[763693] = "-[EAGLView touchesEnded:withEvent:] (EAGLView.mm:455)",
	[1805879] = "luaD_call (ldo.c:379)",
	[994667] = "dbResFile::loadFromZip(std::string const&, std::string const&, bool) (dbResFile.cpp:33)",
	[1147717] = "dbUITabControl::_selectedBtnChanged(dbUIWidget*, dbUIEvent*) (dbUITabControl.cpp:51)",
	[3426751] = "+[UCASIHTTPRequest runRequests] + 151",
	[1143635] = "dbUIEventScriptHandler::execute(dbUIWidget*, dbUIEvent*) (dbUIEventHandler.cpp:69)",
	[787973] = "cocos2d::CCDisplayLinkDirector::mainLoop() (CCDirector.cpp:966)",
	[1782387] = "toluafix_get_function_by_refid (tolua_fix.cpp:241)",
	[1187077] = "dbUILayer::ccTouchMoved(cocos2d::CCTouch*, cocos2d::CCEvent*) (dbUILayer.cpp:254)",
	[1929561] = "tolua_DBUI_dbUITagText_getString00(lua_State*) (LuaDBUI.cpp:10150)",
	[862841] = "cocos2d::unz64local_GetCurrentFileInfoInternal(void*, cocos2d::unz_file_info64_s*, cocos2d::unz_file_info64_internal_s*, char*, unsigned long, void*, unsigned long, char*, unsigned long) (unzip.cpp:948)",
	[215009] = "int dbLuaEngine::executeGlobalFunctionWithData<IOBufferHelper*, bool>(char const*, IOBufferHelper*, bool) (dbLuaEngine.h:129)",
	[1927527] = "tolua_DBUI_dbUITabControl_setSelectedBtn00(lua_State*) (LuaDBUI.cpp:9563)",
	[1805399] = "luaD_rawrunprotected (ldo.c:119)",
	[1437483] = "dbLuaStack::executeFunction(int) (dbLuaStack.cpp:549)",
	[1018701] = "dbZipMgr::getDataFromZip(std::string const&, std::string const&, unsigned char*&, unsigned long&, bool) (dbZipMgr.cpp:44)",
	[1034798] = "DES_SBOX (DES.cpp:258)",
	[776489] = "-[EAGLView touchesEnded:withEvent:] (EAGLView.mm:455)",
	[222229] = "int dbLuaEngine::executeGlobalFunctionWithData<IOBufferHelper*, bool>(char const*, IOBufferHelper*, bool) (dbLuaEngine.h:129)",
	[1805927] = "luaD_precall (ldo.c:320)",
	[1888200] = "DBUI_dbUIWidget___index(lua_State*) (LuaDBUI.cpp:11013)",
	[1138565] = "dbUIDelegate::operator()(dbUIWidget*, dbUIEvent*) (dbUIDelegate.cpp:41)",
	[1854989] = "class_index_event (tolua_event.c:179)",
	[1784985] = "lua_rawget (lapi.c:562)",
	[2647067] = "packstr(unsigned char*, char*) (NetConvt.cpp:87)",
	[2640941] = "NetSocket::update(float) (boost_shared_ptr.h:666)",
	[133317] = "tolua_DBNET_packstr00(lua_State*) (LuaDBNet.cpp:434)",
	[788509] = "cocos2d::CCScheduler::update(float) (CCScheduler.cpp:831)",
	[1186614] = "dbUILayer::ccTouchEnded(cocos2d::CCTouch*, cocos2d::CCEvent*) (dbUILayer.cpp:174)",
	[773693] = "cocos2d::CCDirector::drawScene() (CCDirector.cpp:217)",
	[2647093] = "DataStick::onReceiveData(std::tr1::shared_ptr<IOBufferHelper> const&) (DataStick.cpp:30)",
	[1186623] = "dbUILayer::ccTouchEnded(cocos2d::CCTouch*, cocos2d::CCEvent*) (dbUILayer.cpp:174)",
	[1850413] = "luaV_execute (lvm.c:441)",
	[2640981] = "NetSocket::update(float) (boost_shared_ptr.h:666)",
	[1147291] = "dbUITabControl::setContent(int) (dbUITabControl.cpp:187)",
	[1018729] = "dbZipMgr::getDataFromZip(std::string const&, std::string const&, unsigned char*&, unsigned long&, bool) (dbZipMgr.cpp:50)",
	[862109] = "cocos2d::unz64local_getLong(cocos2d::zlib_filefunc64_32_def_s const*, void*, unsigned long*) (unzip.cpp:280)",
	[126097] = "tolua_DBNET_packstr00(lua_State*) (LuaDBNet.cpp:434)",
	[801305] = "cocos2d::CCScheduler::update(float) (CCScheduler.cpp:831)",
	[1849421] = "luaV_execute (lvm.c:591)",
	[786489] = "cocos2d::CCDirector::drawScene() (CCDirector.cpp:217)",
	[1806503] = "luaD_precall (ldo.c:320)",
	[925483] = "cocos2d::CCTouchDispatcher::touches(cocos2d::CCSet*, cocos2d::CCEvent*, unsigned int) (CCTouchDispatcher.cpp:382)",
	[1139141] = "dbUIDelegate::operator()(dbUIWidget*, dbUIEvent*) (dbUIDelegate.cpp:41)",
	[1233166] = "dbUIScrollArea::dragMove(cocos2d::CCPoint const&, cocos2d::CCPoint const&) (dbUIScrollArea.cpp:178)",
	[1012101] = "dbResTextureLoader::loadResFromZipThreadSafe(std::string const&, std::string const&) (dbResTextureLoader.cpp:178)",
	[1845863] = "callTMres (lvm.c:90)",
	[90105] = "dbCoolDownSys::_callRefresh(tCoolDownInfo const&, float) (dbCoolDownSys.cpp:363)",
	[1807031] = "luaD_pcall (ldo.c:464)",
	[2646193] = "DataStick::_onNewTcpData(bool, std::tr1::shared_ptr<IOBufferHelper>, unsigned int) (DataStick.cpp:187)",
	[802597] = "cocos2d::CCScheduler::update(float) (CCScheduler.cpp:831)",
	[862897] = "cocos2d::unz64local_GetCurrentFileInfoInternal(void*, cocos2d::unz_file_info64_s*, cocos2d::unz_file_info64_internal_s*, char*, unsigned long, void*, unsigned long, char*, unsigned long) (unzip.cpp:964)",
	[787781] = "cocos2d::CCDirector::drawScene() (CCDirector.cpp:217)",
	[1850989] = "luaV_execute (lvm.c:441)",
	[1923042] = "tolua_DBUI_dbUIScrollList_scrollToIndex00(lua_State*) (LuaDBUI.cpp:7728)",
	[970467] = "-[Sdk_91 alertView:clickedButtonAtIndex:] (Sdk_91.m:282)",
	[1429421] = "dbLuaEngine::executeSchedule(int, float, cocos2d::CCNode*) (dbLuaEngine.cpp:169)",
	[751251] = "cocos2d::CCImage::initWithImageData(void*, int, cocos2d::CCImage::EImageFormat, int, int, int) (CCImage.mm:96)",
	[224031] = "NetTcpSys::connect(std::string const&, int) (dbNetTcpSys.cpp:34)",
	[1821875] = "ll_require (loadlib.c:474)",
	[1215319] = "dbUIWidget::clicked(cocos2d::CCPoint const&) (dbUIWidget.cpp:98)",
	[1923055] = "tolua_DBUI_dbUIScrollList_scrollToIndex00(lua_State*) (LuaDBUI.cpp:7728)",
	[1929192] = "tolua_DBUI_dbUITabControl_getContent00(lua_State*) (LuaDBUI.cpp:9808)",
	[1245477] = "dbUICheckButtonGroup::setSelectedBtn(unsigned int) (dbUICheckButtonGroup.cpp:133)",
	[44463] = "main (main.m:14)",
	[231251] = "NetTcpSys::connect(std::string const&, int) (dbNetTcpSys.cpp:34)",
	[1849997] = "luaV_execute (lvm.c:591)",
	[222373] = "int dbLuaEngine::executeGlobalFunctionWithData<IOBufferHelper*, bool>(char const*, IOBufferHelper*, bool) (dbLuaEngine.h:129)",
	[734657] = "cocos2d::CCEGLViewProtocol::handleTouchesEnd(int, int*, float*, float*) (CCEGLViewProtocol.cpp:307)",
	[228889] = "dbNetSys::_startConnectGCS(void*) (dbNetSys.cpp:214)",
	[939571] = "cocos2d::CCTouchDispatcher::touches(cocos2d::CCSet*, cocos2d::CCEvent*, unsigned int) (CCTouchDispatcher.cpp:382)",
	[1029763] = "EFile::DecodeFile(std::string const&, char**, unsigned long&, char const*, int) (dbEfile.cpp:83)",
	[829453] = "cocos2d::CCObject::release() (CCObject.cpp:88)",
	[1234773] = "dbUIScrollArea::clicked(cocos2d::CCPoint const&) (dbUIScrollArea.cpp:261)",
	[387262] = "dbMapObjState_MoveToward::update(float) (dbMapObjState_MoveToward.cpp:173)",
	[1807607] = "luaD_pcall (ldo.c:464)",
	[972281] = "dbGarbageCollector::cleanupGarbage(IResource*) (dbGarbageCollector.cpp:167)",
	[1437647] = "dbLuaStack::executeFunctionByHandler(int, int) (dbLuaStack.cpp:588)",
	[820772] = "cocos2d::CCPoint::operator=(cocos2d::CCPoint const&) (CCGeometry.cpp:48)",
	[124347] = "dbGameSys::_destory() (dbGameSys.cpp:171)",
	[866254] = "cocos2d::unzOpenInternal(void const*, cocos2d::zlib_filefunc64_32_def_s*, int) (unzip.cpp:524)",
	[2640248] = "NetSocket::getLastError(std::string*) (NetSocket.cpp:484)",
	[69287] = "main (main.m:14)",
	[1187275] = "non-virtual thunk to dbUILayer::ccTouchEnded(cocos2d::CCTouch*, cocos2d::CCEvent*) + 11",
	[1187787] = "dbUILayer::ccTouchEnded(cocos2d::CCTouch*, cocos2d::CCEvent*) (dbUILayer.cpp:197)",
	[1822451] = "ll_require (loadlib.c:474)",
	[1215895] = "dbUIWidget::clicked(cocos2d::CCPoint const&) (dbUIWidget.cpp:98)",
	[1929768] = "tolua_DBUI_dbUITabControl_getContent00(lua_State*) (LuaDBUI.cpp:9808)",
	[1889400] = "tolua_DBUI_dbUIWidget_setString00(lua_State*) (LuaDBUI.cpp:198)",
	[1930281] = "tolua_DBUI_dbUITagText_getString00(lua_State*) (LuaDBUI.cpp:10150)",
	[1228682] = "dbUIScrollArea::touchUp(cocos2d::CCPoint const&) (dbUIScrollArea.cpp:309)",
	[1428999] = "non-virtual thunk to dbLuaEngine::executeUIEvent(int const&, dbUIWidget*, dbUIEvent*) (dbLuaEngine.cpp:310)",
	[1785167] = "lua_pcall (lapi.c:822)",
	[1438199] = "dbLuaStack::executeFunction(int) (dbLuaStack.cpp:549)",
	[221423] = "dbNetSys::updateNet(float) (dbNetSys.cpp:272)",
	[721913] = "cocos2d::CCEGLViewProtocol::handleTouchesEnd(int, int*, float*, float*) (CCEGLViewProtocol.cpp:307)",
	[1036691] = "DES_DecryptFileToBuf (DES.cpp:484)",
	[2639273] = "HttpOp::execute() (HttpOp.cpp:204)",
	[1002967] = "loadRes(void*) (dbResourceMgr.cpp:115)",
	[2641323] = "NetSocket::init(std::string const&, int) (NetSocket.cpp:65)",
	[1142343] = "dbUIEventScriptHandler::execute(dbUIWidget*, dbUIEvent*) (dbUIEventHandler.cpp:69)",
	[468015] = "0x89000 + 468015",
	[1847015] = "luaV_gettable (lvm.c:125)",
	[11384] = "start + 40",
	[1888920] = "DBUI_dbUIWidget___index(lua_State*) (LuaDBUI.cpp:11013)",
	[1430555] = "cocos2dx_lua_loader (Cocos2dxLuaLoader.cpp:136)",
	[1807165] = "luaD_call (ldo.c:377)",
	[1012173] = "dbResTextureLoader::loadResFromZipThreadSafe(std::string const&, std::string const&) (dbResTextureLoader.cpp:183)",
	[1804103] = "luaD_rawrunprotected (ldo.c:119)",
	[786569] = "cocos2d::CCDirector::drawScene() (CCDirector.cpp:258)",
	[1187330] = "dbUILayer::ccTouchEnded(cocos2d::CCTouch*, cocos2d::CCEvent*) (dbUILayer.cpp:174)",
	[1807175] = "luaD_call (ldo.c:379)",
	[1149009] = "dbUITabControl::_selectedBtnChanged(dbUIWidget*, dbUIEvent*) (dbUITabControl.cpp:51)",
	[1785205] = "f_call (lapi.c:801)",
	[861945] = "cocos2d::unz64local_getByte(cocos2d::zlib_filefunc64_32_def_s const*, void*, int*) (unzip.cpp:217)",
	[972577] = "dbGarbageCollector::addGarbage(dbResourceCacheInfo*) (dbGarbageCollector.cpp:72)",
	[1187339] = "dbUILayer::ccTouchEnded(cocos2d::CCTouch*, cocos2d::CCEvent*) (dbUILayer.cpp:174)",
	[1002983] = "loadRes(void*) (dbResourceMgr.cpp:119)",
	[1188363] = "dbUILayer::ccTouchEnded(cocos2d::CCTouch*, cocos2d::CCEvent*) (dbUILayer.cpp:197)",
	[780699] = "cocos2d::ccGLDeleteTexture(unsigned int) (ccGLStateCache.cpp:168)",
	[1841423] = "luaH_get (ltable.c:478)",
	[1842959] = "foreach (ltablib.c:48)",
	[1853693] = "class_index_event (tolua_event.c:179)",
	[2646517] = "DataStick::onReceiveData(std::tr1::shared_ptr<IOBufferHelper> const&) (DataStick.cpp:30)",
	[926085] = "non-virtual thunk to cocos2d::CCTouchDispatcher::touchesEnded(cocos2d::CCSet*, cocos2d::CCEvent*) + 21",
	[2646535] = "DataStick::_unpack(bool, std::tr1::shared_ptr<IOBufferHelper>, unsigned int, unsigned int&, bool&, unsigned int&) (DataStick.cpp:162)",
	[1928823] = "tolua_DBUI_dbUITabControl_setSelectedBtn00(lua_State*) (LuaDBUI.cpp:9563)",
	[1438775] = "dbLuaStack::executeFunction(int) (dbLuaStack.cpp:549)",
	[788377] = "cocos2d::CCScheduler::update(float) (CCScheduler.cpp:789)",
	[736001] = "cocos2d::CCEGLViewProtocol::handleTouchesEnd(int, int*, float*, float*) (CCEGLViewProtocol.cpp:307)",
	[778159] = "-[EAGLView swapBuffers] (EAGLView.mm:330)",
	[221433] = "dbNetSys::updateNet(float) (dbNetSys.cpp:276)",
	[469821] = "-[PPZhuShou alertView:clickedButtonAtIndex:] (PPZhuShou.m:139)",
	[2369621] = "Curl_do_perform + 813",
	[991255] = "dbResourceMgr::unloadResource(IResource*) (dbResourceMgr.cpp:333)",
	[1846583] = "callTMres (lvm.c:90)",
	[1924256] = "tolua_DBUI_dbUIScrollList_removeWidget00(lua_State*) (LuaDBUI.cpp:8338)",
	[228653] = "dbNetSys::updateNet(float) (dbNetSys.cpp:276)",
	[938881] = "non-virtual thunk to cocos2d::CCTouchDispatcher::touchesEnded(cocos2d::CCSet*, cocos2d::CCEvent*) + 21",
	[1806106] = "luaD_precall (ldo.c:277)",
	[223805] = "NetTcpSys::updateNet(float) (dbNetTcpSys.cpp:66)",
	[2640365] = "NetSocket::update(float) (boost_shared_ptr.h:666)",
	[773885] = "cocos2d::CCDisplayLinkDirector::mainLoop() (CCDirector.cpp:966)",
	[1785795] = "lua_call (lapi.c:783)",
	[2647643] = "packstr(unsigned char*, char*) (NetConvt.cpp:87)",
	[1578480] = "tolua_Cocos2d_CCNode_getTag00(lua_State*) (LuaCocos2d.cpp:13247)",
	[1806589] = "luaD_call (ldo.c:377)",
	[221669] = "dbNetSys::_startConnectGCS(void*) (dbNetSys.cpp:214)",
	[1805207] = "luaD_precall (ldo.c:320)",
	[764125] = "-[EAGLView touchesMoved:withEvent:] (EAGLView.mm:434)",
	[1001485] = "dbResourceMgr::loadResourceFromZipThreadSafe(int, std::string const&, std::string const&) (dbResourceMgr.cpp:626)",
	[1577304] = "tolua_Cocos2d_CCNode_setVisible00(lua_State*) (LuaCocos2d.cpp:13066)",
	[223939] = "NetTcpSys::connect(std::string const&, int) (dbNetTcpSys.cpp:29)",
	[1036859] = "DES_DecryptBufToBuf (DES.cpp:548)",
	[988201] = "dbResourceMgr::removeResource(IResource*) (dbResourceMgr.cpp:678)",
	[1187851] = "non-virtual thunk to dbUILayer::ccTouchEnded(cocos2d::CCTouch*, cocos2d::CCEvent*) + 11",
	[1137849] = "dbUIDelegate::operator()(dbUIWidget*, dbUIEvent*) (dbUIDelegate.cpp:41)",
	[788453] = "cocos2d::CCScheduler::update(float) (CCScheduler.cpp:807)",
	[1848701] = "luaV_execute (lvm.c:591)",
	[214795] = "DataListener::onReceiveData(std::tr1::shared_ptr<IOBufferHelper> const&) (DataListener.cpp:22)",
	[1924282] = "tolua_DBUI_dbUIScrollList_removeAllWidgets00(lua_State*) (LuaDBUI.cpp:8369)",
	[1806599] = "luaD_call (ldo.c:379)",
	[1431243] = "cocos2dx_lua_loader (Cocos2dxLuaLoader.cpp:145)",
	[972357] = "dbGarbageCollector::_cleanupGarbage(unsigned long) (dbGarbageCollector.cpp:248)",
	[2647683] = "packstr(unsigned char*, char*) (NetConvt.cpp:87)",
	[1786463] = "lua_pcall (lapi.c:822)",
	[940173] = "non-virtual thunk to cocos2d::CCTouchDispatcher::touchesEnded(cocos2d::CCSet*, cocos2d::CCEvent*) + 21",
	[468299] = "main (main.m:14)",
	[126465] = "dbGameSys::~dbGameSys() (dbGameSys.cpp:53)",
	[722265] = "cocos2d::CCEGLViewProtocol::handleTouchesMove(int, int*, float*, float*) (CCEGLViewProtocol.cpp:253)",
	[3566023] = "uncaught_exception_handler + 27",
	[2646495] = "DataStick::_unpack(bool, std::tr1::shared_ptr<IOBufferHelper>, unsigned int, unsigned int&, bool&, unsigned int&) (DataStick.cpp:162)",
	[802719] = "cocos2d::CCScheduler::update(float) (CCScheduler.cpp:866)",
	[1889496] = "DBUI_dbUIWidget___index(lua_State*) (LuaDBUI.cpp:11013)",
	[938279] = "cocos2d::CCTouchDispatcher::touches(cocos2d::CCSet*, cocos2d::CCEvent*, unsigned int) (CCTouchDispatcher.cpp:382)",
	[2789763] = "+[ASIHTTPRequest runRequests] (ASIHTTPRequest.m:4797)",
	[1438337] = "dbLuaStack::executeFunctionByHandler(int, int) (dbLuaStack.cpp:577)",
	[1849693] = "luaV_execute (lvm.c:441)",
	[1144393] = "dbUITabControl::setSelectedBtn(int) (dbUITabControl.cpp:315)",
	[221473] = "dbNetSys::_connectGCS() (dbNetSys.cpp:223)",
	[133461] = "tolua_DBNET_packstr00(lua_State*) (LuaDBNet.cpp:434)",
	[394482] = "dbMapObjState_MoveToward::update(float) (dbMapObjState_MoveToward.cpp:173)",
	[1145999] = "dbUITabControl::setContent(int) (dbUITabControl.cpp:187)",
	[926129] = "non-virtual thunk to cocos2d::CCTouchDispatcher::touchesMoved(cocos2d::CCSet*, cocos2d::CCEvent*) + 21",
	[1786501] = "f_call (lapi.c:801)",
	[798403] = "cocos2d::CCTimer::update(float) (CCScheduler.cpp:203)",
	[228787] = "dbNetSys::updateNet(float) (dbNetSys.cpp:272)",
	[228643] = "dbNetSys::updateNet(float) (dbNetSys.cpp:272)",
	[902881] = "cocos2d::CCTexture2D::~CCTexture2D() (CCTexture2D.cpp:87)",
	[1576584] = "tolua_Cocos2d_CCNode_setVisible00(lua_State*) (LuaCocos2d.cpp:13066)",
	[1846439] = "luaV_gettable (lvm.c:125)",
	[1187071] = "dbUILayer::ccTouchEnded(cocos2d::CCTouch*, cocos2d::CCEvent*) (dbUILayer.cpp:197)",
	[1143101] = "dbUITabControl::setSelectedBtn(int) (dbUITabControl.cpp:315)",
	[222015] = "DataListener::onReceiveData(std::tr1::shared_ptr<IOBufferHelper> const&) (DataListener.cpp:22)",
	[2647133] = "DataStick::onReceiveData(std::tr1::shared_ptr<IOBufferHelper> const&) (DataStick.cpp:30)",
	[1026291] = "dbResUtility::getZipFile(char const*, bool) (dbResUtility_ios.mm:75)",
	[1437955] = "dbLuaStack::pushFunctionByHandler(int) (dbLuaStack.cpp:502)",
	[1143417] = "dbUIEventHandler::execute(dbUIWidget*, dbUIEvent*) (dbUIEventHandler.cpp:31)",
	[1847159] = "callTMres (lvm.c:90)",
	[997677] = "dbResTexture::~dbResTexture() (dbResTexture.cpp:15)",
	[1142125] = "dbUIEventHandler::execute(dbUIWidget*, dbUIEvent*) (dbUIEventHandler.cpp:31)",
	[231169] = "NetTcpSys::updateNet(float) (dbNetTcpSys.cpp:66)",
	[1438363] = "dbLuaStack::executeFunctionByHandler(int, int) (dbLuaStack.cpp:588)",
	[228693] = "dbNetSys::_connectGCS() (dbNetSys.cpp:223)",
	[1244185] = "dbUICheckButtonGroup::setSelectedBtn(unsigned int) (dbUICheckButtonGroup.cpp:133)",
	[231025] = "NetTcpSys::updateNet(float) (dbNetTcpSys.cpp:66)",
	[222159] = "DataListener::onReceiveData(std::tr1::shared_ptr<IOBufferHelper> const&) (DataListener.cpp:22)",
	[2368763] = "Curl_perform + 63",
	[1276893] = "dbUIMainSkin::~dbUIMainSkin() (dbUISkin.cpp:53)",
	[70545] = "AppDelegate::~AppDelegate() (AppDelegate.cpp:25)",
	[1186559] = "non-virtual thunk to dbUILayer::ccTouchEnded(cocos2d::CCTouch*, cocos2d::CCEvent*) + 11",
	[2639632] = "NetSocket::getLastError(std::string*) (NetSocket.cpp:484)",
	[712760] = "cocos2d::CCActionManager::update(float) (CCActionManager.cpp:346)",
	[2256935] = "curl_easy_perform + 127",
	[1001517] = "dbResourceMgr::loadResourceThreadSafe(int, std::string const&) (dbResourceMgr.cpp:609)",
	[1785075] = "lua_call (lapi.c:783)",
	[862015] = "cocos2d::unz64local_getShort(cocos2d::zlib_filefunc64_32_def_s const*, void*, unsigned long*) (unzip.cpp:248)",
	[777781] = "-[EAGLView touchesEnded:withEvent:] (EAGLView.mm:455)",
	[2646769] = "DataStick::_onNewTcpData(bool, std::tr1::shared_ptr<IOBufferHelper>, unsigned int) (DataStick.cpp:187)",
	[1786371] = "lua_call (lapi.c:783)",
	[1923562] = "tolua_DBUI_dbUIScrollList_removeAllWidgets00(lua_State*) (LuaDBUI.cpp:8369)",
	[2646809] = "DataStick::_onNewTcpData(bool, std::tr1::shared_ptr<IOBufferHelper>, unsigned int) (DataStick.cpp:187)",
	[862855] = "cocos2d::unz64local_GetCurrentFileInfoInternal(void*, cocos2d::unz_file_info64_s*, cocos2d::unz_file_info64_internal_s*, char*, unsigned long, void*, unsigned long, char*, unsigned long) (unzip.cpp:951)",
	[784091] = "cocos2d::CCTimer::update(float) (CCScheduler.cpp:163)",
	[1892864] = "tolua_DBUI_dbUIWidget_changeSkin00(lua_State*) (LuaDBUI.cpp:1176)",
}

local function convert_ios_crash_log(filename)
	local file = io.open(filename, 'r')
	local content = file:read('*a')

	content = string.gsub(content, '(%d+%s*(zxy)%s*0x%x+ )(0x%x+ %+ (%d+))',
		function(tmp, _type, base_add_offset, offset)
			local crash_t = nil
			if _type == 'zxy' then
				crash_t = crash_func_table
			elseif _type == 'libsystem_kernel.dylib' then
				crash_t = libsystem_kernel_dylib_crash_func_tablelocal
			end

			if crash_t then
				local convert_msg = crash_t[tonumber(offset)]
				if convert_msg == nil then
					return tmp..base_add_offset
				else
					return tmp..convert_msg
				end
			else
				return tmp..base_add_offset
			end
			--[[
			local _,_,offset = string.find(base_add_offset, '0x%x+ %+ (%d+)')
			offset = tonumber(offset)

			local convert_msg = crash_func_table[offset]
			if convert_msg == nil then
				return tmp..base_add_offset
			else
				return tmp..convert_msg
			end]]
		end)

	file:close()

	file = io.open(filename, 'w+')
	file:write(content)
	file:flush()
	file:close()
end

local function convert_all(rootpath)
	local function convert_dir(rootpath)
		for file in lfs.dir(rootpath) do
			if file ~= '.' and file ~= '..' then
				local path = rootpath .. '\\' .. file
				local attr = lfs.attributes(path)

				if attr.mode == 'directory' then
					convert_dir(path)
				elseif string.find(file, 'crash_readable') then
					convert_ios_crash_log(path)
				end
			end
		end
	end
	convert_dir(rootpath)
end

--convert_all(rootpath..'\\'..date_folder_name)
convert_all(rootpath..'\\'..date_folder_name)
