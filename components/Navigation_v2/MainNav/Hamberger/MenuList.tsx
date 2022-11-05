// import { keyframes, css } from '@emotion/react';
import React from 'react'
import styled from '@emotion/styled'
import MenuItem from './MenuItem'

const MenuWrapper = styled.div<{ open: string }>`
  position: fixed;
  top: 0;
  left: 0;
  height: ${({ open }) => (open ? '100%' : 0)};
  width: 100vw;
  display: flex;
  flex-direction: column;
  background: #16b9b3;
  opacity: 0.95;
  color: #fafafa;
  transition: height 0.3s ease;
  z-index: 100;
`

const MenuListWrapper = styled.div`
  padding: 3rem;
  margin-top: 30px;
  position: relative;
  z-index: 100;
`

const Menu = ({ open, list, onCloseMenu }) => {
  return (
    <MenuWrapper open={open}>
      {open && (
        <MenuListWrapper>
          {list.map((value, index) => {
            return (
              <MenuItem
                key={value.name}
                delay={`${index * 0.1}s`}
                onClick={onCloseMenu}
                text={value.name}
                link={value.link}
              />
            )
          })}
        </MenuListWrapper>
      )}
    </MenuWrapper>
  )
}

export default Menu
