import React from 'react'
import { getBlockParentPage, idToUuid } from 'notion-utils'
import { getCanonicalPageUrl } from 'lib/map-page-url'
import { SitemapStream, streamToPromise } from 'sitemap'
import { getSiteMap } from 'lib/get-site-map'
import { NotionPage } from '../components/NotionPage'
import * as config from 'lib/config'
import { NextApiRequest, NextApiResponse, NextPageContext } from "next";

interface PageContext extends NextPageContext {
  req: NextApiRequest;
  res: NextApiResponse;
}

const siteURL = 'https://blog.daoedu.tw'

export default function Sitemap(props) {
  return <NotionPage {...props} />
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
Sitemap.getInitialProps = async ({ req, res }: PageContext) => {
  const ttlMinutes = 24 * 60 // 24 hours
  const ttlSeconds = ttlMinutes * 60

  try {
    const siteMap = await getSiteMap()
    const smStream = new SitemapStream({ hostname: siteURL })

    for (const pagePath of Object.keys(siteMap.canonicalPageMap)) {
      const pageId = siteMap.canonicalPageMap[pagePath]
      const recordMap = siteMap.pageMap[pageId]
      if (!recordMap) continue

      const keys = Object.keys(recordMap?.block || {})
      const block = recordMap?.block?.[keys[0]]?.value
      if (!block) continue

      const parentPage = getBlockParentPage(block, recordMap)
      const isBlogPost =
        block.type === 'page' &&
        block.parent_table === 'collection' &&
        parentPage?.id === idToUuid(config.rootNotionPageId)
      if (!isBlogPost) {
        continue
      }

      const url = getCanonicalPageUrl(config.site, recordMap)(pageId)
      const lastUpdatedTime = new Date(block['last_edited_time']).toISOString()
      const publishedTime = new Date(block['created_time']).toISOString()

      smStream.write({
        url: url,
        changefreq: 'daily',
        priority: 1,
        lastmod: lastUpdatedTime || publishedTime
      })
    }

    // End sitemap stream
    smStream.end()

    // XML sitemap string
    const sitemapOutput = (await streamToPromise(smStream)).toString()

    res?.setHeader(
      'Cache-Control',
      `public, max-age=${ttlSeconds}, stale-while-revalidate=${ttlSeconds}`
    )

    res?.setHeader('Content-Type', 'text/xml; charset=utf-8')
    res?.end(sitemapOutput)
    return {
      props: {}
    }
  } catch (error) {
    // console.error(error)
    // res?.status(500).end()
    // return { notFound: true }
    return {
      props: {}
    }
  }
}
