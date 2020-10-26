const ENV = 'dev';

const HOST_MAP = {
  'dev': 'https://gateway-dev.e-medclouds.com',
  'qa': 'https://gateway-dev.e-medclouds.com',
  'prod': 'https://gateway.e-medclouds.com',
};

const system = 'doctor';
const client = 'mobile';

final host = HOST_MAP[ENV];

final servers = {
  'server': '$host/medclouds-server/$system/$client',
  'ucenter': '$host/medclouds-ucenter/$system/$client',
  'foundation': '$host/medclouds-foundation/$client',
  'foundationWeb': '$host/medclouds-foundation/web',
  'foundationSystem': '$host/medclouds-foundation/$system/$client',
  'developer': '$host/medclouds-foundation/developer/$client',
  'dtp': '$host/medclouds-dtp/$system/$client',
  'sso': '$host/medclouds-ucenter/$client',
  'uCenterCommon': '$host',
};
