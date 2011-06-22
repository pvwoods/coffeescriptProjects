_log = (x) -> console.log x

_logAtLevel = (x, y) -> _log x + ':: ' + y

exports.log = exports.og = _log
exports.logAtLevel = exports.lvl = _logAtLevel
exports.debug = exports.dbg = (x) -> _logAtLevel 'DEBUG', x
exports.error = exports.err = (x) -> _logAtLevel 'ERROR', x
exports.info = exports.nfo = (x) -> _logAtLevel 'INFO', x
exports.warning = exports.wrn = (x) -> _logAtLevel 'WARNING', x

