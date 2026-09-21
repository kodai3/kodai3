#!/usr/bin/env node
import open from "open";

const links = {
  github: "https://github.com/kodai3",
  twitter: "https://twitter.com/r34b26",
  facebook: "https://www.facebook.com/profile.php?id=100006071802580",
};

const help = () =>
  console.log(`
Usage: kodai3 <command>

where <command> is one of:
    help       what you see now
    whoami     show who am i
    github     open github   ${links.github}
    twitter    open twitter  ${links.twitter}
    facebook   open facebook ${links.facebook}

Machine setup (clone this repo, not npx):
    ./scripts/setup.sh
`);

const whoami = () =>
  console.log(`
Name            :    Kodai Suzuki
Date of birth   :    1997
Work for        :    Gaudiy
Hobby           :    Car (FD3S Type RZ & S2000 AP2) & Motorcycle (Kawasaki Z900RS 50th & Husqvarna Vipilen 401)
`);

const argv = process.argv.slice(2);

if (argv.length !== 1) {
  help();
} else {
  switch (argv[0].toLocaleLowerCase()) {
    case "help":
      help();
      break;

    case "whoami":
      whoami();
      break;

    case "github":
      await open(links.github);
      break;

    case "twitter":
      await open(links.twitter);
      break;

    case "facebook":
      await open(links.facebook);
      break;

    default:
      help();
  }
}

process.exit(0);
