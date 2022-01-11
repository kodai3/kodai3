#!/usr/bin/env node
import open from 'open';

const links = {
    github: "https://github.com/kodai3",
    twitter: "https://twitter.com/r34b26",
    facebook: "https://www.facebook.com/profile.php?id=100006071802580"
}

const help = () => console.log(`
Usage: kodai3 <command>

where <command> is one of:
    help       what you see now
    whoami     show who am i
    github     oepn github   ${links.github}
    twitter    open twitter  ${links.twitter}
    facebook   open facebook ${links.facebook}
`)

const whoami = () => console.log(`
Name            :    Kodai Suzuki
Date of birth   :    1997
Work for        :    Gaudiy
Hobby           :    Motorcycle (Husqvarna Vipilen 401 & Suzuki GSX-R750)
`)

const argv = process.argv.slice(2);

if (argv.length !== 1) {
    help();
    process.exit(0);
}

switch (argv[0].toLocaleLowerCase()) {
    case 'help':
        help();
        process.exit(0);

    case 'whoami':
        whoami();
        process.exit(0);

    case 'github':
        open(links.github).then(() => {
            process.exit(0);
        });
        break;

    case 'twitter':
        open(links.twitter).then(() => {
            process.exit(0);
        })
        break;

    case 'facebook':
        open(links.facebook).then(() => {
            process.exit(0);
        })
        break;

    default:
        help();
        process.exit(0);
}
