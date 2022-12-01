import React from 'react'
import styled from '@emotion/styled'
import { Search } from "../../../react-notion-x"

const LinkListWrapper = styled.ul`
  display: flex;
  justify-content: space-around;
  align-items: center;
  position: relative;
  li {
    cursor: pointer;
    font-weight: 500;
  }
  @media (max-width: 767px) {
    display: none;
  }
`

const SubListWrapper = styled.div`
  /* color: rgba(255, 255, 255, 0.7); */
  color: white;
  .login,
  .logout {
    cursor: pointer;
  }
  .icon {
    width: 32px;
    /* border-radius: 50%; */
  }

  .coin-field {
    display: flex;
    align-items: center;
    span {
      margin: 10px;
    }
  }

  @media (max-width: 767px) {
    display: none;
  }
`

const SubList = ({ block }) => {
  return (
    <SubListWrapper>

      <LinkListWrapper>
        <li>
          <Search block={block} title={null} />
        </li>
        <li>
          <a href='https://www.daoedu.tw/contribute/resource' target="_blank" rel="noreferrer">
            <p className='login' role='presentation'>
              新增資源
            </p>
          </a>
        </li>
      </LinkListWrapper>
    </SubListWrapper>
  )
}

export default SubList
