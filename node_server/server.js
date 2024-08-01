import express from "express";
import bodyParser from "body-parser";
import cors from "cors";
import RSSParser from "rss-parser";

// creating the server
const app = express();
app.use(bodyParser.json());
app.use(cors());

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });

// handling history
let searchHistory = [];

function updateSearchHistory(username) {
    const index = searchHistory.indexOf(username);
    if (index > -1) { 
        searchHistory.splice(index, 1);
        searchHistory.unshift(username);
    } else {
        searchHistory.unshift(username);
    }

    if (searchHistory.length > 5) {
        searchHistory.pop();
    }
}

// RRS parsing
const parser = new RSSParser();

async function parse(url) {
    const feed = await parser.parseURL(url);
    let feedItems = [];

    feed.items.forEach(item => {
        feedItems.push(item);
    });

    return [feed['title'], feedItems];
}

// HTTP requests 
app.get('/', async (req, res) => {
    res.status(200).json({ 'history' : searchHistory });
});

app.post('/', async (req, res) => {
    let username = req.body.username;
    let title = '';
    let userExist = false;
    let articles = [];
    const feedURLs = [
        `https://medium.com/feed/${username}`,
        `https://medium.com/feed/@${username}`,
        `https://${username}.medium.com/feed`,
    ];
    
    for (let link of feedURLs) {
        try {
            [title, articles] = await parse(link);
            userExist = true;
            break;
        } catch (error) {
            continue;
        }
    }

    if (userExist) {
        updateSearchHistory(username);
        res.status(200).json({ 
            'title' : title, 
            'articles' : articles, 
            'history' : searchHistory, 
            'userExist' : userExist, 
        });
    } else {
        res.status(500).json({ 
            error: 'Failed to fetch RSS feed', 
        });
    }
});