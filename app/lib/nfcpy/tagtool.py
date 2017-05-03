import nfc

def connected(tag):
  print tag

  if isinstance(tag, nfc.tag.tt2.Type2Tag):
    try:
      print('  ' + '\n  '.join(tag.dump()))
    except Exception as e:
      print "error: %s" % e
  else:
    print "error: tag isn't Type2Tag"

clf = nfc.ContactlessFrontend('usb')
clf.connect(rdwr={'on-connect': connected})
